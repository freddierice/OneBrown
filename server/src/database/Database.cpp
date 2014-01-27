#include "Database.h"

Database::Database()
{
    m_driver = get_driver_instance();
    m_conn = m_driver->connect("tcp://54.200.186.84:3306","red","password");
    m_conn->setSchema("onebrown");
    
    m_salt = new char[16];
    m_hash = new char[32];
    m_digest = new char[32];
    m_session = new char[32];
}

Database::~Database()
{
    delete m_conn;
    
    delete m_salt;
    delete m_hash;
    delete m_digest;
    delete m_session;
}

LoginStatus Database::login(std::string session)
{
    LoginStatus ls;
    
    Utility::base64ToBytes(m_session,32,session);
    
    DataBuf sessionBuffer((char *)m_session,32);
    std::istream sessionStream(&sessionBuffer);
    
    m_stmt = m_conn->prepareStatement("SELECT * FROM users WHERE session=?");
    m_stmt->setBlob(1,&sessionStream);
    m_res = m_stmt->executeQuery();
    if(m_res->next()){
        m_id = m_res->getInt("id");
        m_email = m_res->getString("email");
        m_res->getBlob("session")->read(m_session,32);
        ls = LoginStatus::SUCCESS;
    }else{
        ls = LoginStatus::FAILURE;
    }
    return ls;
}

LoginStatus Database::login(std::string user, std::string pass)
{
    LoginStatus ls;
    int pass_len;
    char *message;
    
    Utility::sqlClean(user);
    pass_len = pass.length();
    message = new char[pass_len+16];
    
    try{
        m_stmt = m_conn->prepareStatement("SELECT * FROM users WHERE email=?");
        m_stmt->setString(1,user);
        m_res = m_stmt->executeQuery();
        
        if(m_res->next()){
            m_id = m_res->getInt("id");
            m_email = m_res->getString("email");
            m_res->getBlob("hash")->read(m_hash,32);
            m_res->getBlob("salt")->read(m_salt,16);
            if(!m_res->getBlob("session")->read(m_session,32)){
                RAND_bytes((unsigned char *)m_session,32);
                DataBuf sessionBuffer((char *)m_session,32);
                std::istream sessionStream(&sessionBuffer);
                delete m_stmt;
                m_stmt = m_conn->prepareStatement("UPDATE users SET session=? WHERE id=?");
                m_stmt->setBlob(1,&sessionStream);
                m_stmt->setInt(2,m_id);
                m_stmt->executeUpdate();
            }
            memcpy(message,pass.c_str(),pass_len);
            memcpy(message+pass_len,m_salt,16);
            Utility::sha256(message,pass_len+16,m_digest);
            
            if(memcmp(m_digest,m_hash,32) == 0)
                ls = LoginStatus::SUCCESS;
            else
                ls = LoginStatus::FAILURE;
        }else
            ls = LoginStatus::FAILURE;
        
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        ls = LoginStatus::DB_FAILURE;
    }
    
    delete message;
    delete m_res;
    delete m_stmt;
    
    return ls;
}

void Database::logout()
{
    m_stmt = m_conn->prepareStatement("UPDATE users SET session=NULL WHERE id=?");
    m_stmt->setInt(1,m_id);
    m_stmt->executeUpdate();
}

void Database::createUser(std::string user, std::string pass)
{
    int pass_len;
    char *message;
    
    pass_len = pass.length();
    message = new char[pass_len+16];
    
    RAND_bytes((unsigned char*)m_salt,16);
    memcpy(message,pass.c_str(),pass_len);
    memcpy(message+pass_len,m_salt,16);
    Utility::sha256(message,16+pass_len,m_digest);
    
    DataBuf saltBuffer((char *)m_salt,16);
    DataBuf hashBuffer((char *)m_digest,32);
    std::istream saltStream(&saltBuffer);
    std::istream hashStream(&hashBuffer);
    
    m_stmt = m_conn->prepareStatement("INSERT INTO users (email,salt,hash) VALUES (?,?,?)");
    m_stmt->setString(1,user);
    m_stmt->setBlob(2,&saltStream);
    m_stmt->setBlob(3,&hashStream);
    m_stmt->executeUpdate();
    delete m_stmt;
}

RegistrationStatus Database::reg(std::string user)
{
    RegistrationStatus rs;
    
    Utility::sqlClean(user);
    
    try{
        m_stmt = m_conn->prepareStatement("SELECT * FROM users WHERE email=?");
        m_stmt->setString(1,user);
        m_res = m_stmt->executeQuery();
        
        if(m_res->next())
            rs = RegistrationStatus::EXISTS;
        else{
            delete m_stmt;
            delete m_res;
            
            m_stmt = m_conn->prepareStatement("SELECT * FROM reg WHERE email=?");
            m_stmt->setString(1,user);
            m_res = m_stmt->executeQuery();
            if(m_res->next()){
                rs = RegistrationStatus::VERIFY;
                m_tries = m_res->getInt("tries");
            }else{
                RAND_bytes((unsigned char*)&m_code,sizeof(m_code));
                
                Email *e = new Email();
                bool good = e->sendCode(user,std::to_string(m_code));
                delete e;
                
                if(!good)
                    return RegistrationStatus::NOT_BROWN;
                
                delete m_stmt;
                m_stmt = m_conn->prepareStatement("INSERT INTO reg(email,code) VALUES (?,?)");
                m_stmt->setString(1,user);
                m_stmt->setUInt(2,(unsigned int)m_code);
                m_stmt->executeUpdate();
                m_tries = 5;
                rs = RegistrationStatus::SUCCESS;
            }
        }
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        rs = RegistrationStatus::DB_FAILURE;
    }
    
    delete m_stmt;
    delete m_res;
    
    return rs;
}

VerificationStatus Database::verify(std::string user, std::string pass, std::string code)
{
    VerificationStatus vs;
    
    
    m_stmt = m_conn->prepareStatement("SELECT * FROM reg WHERE email=?");
    m_stmt->setString(1,user);
    m_res = m_stmt->executeQuery();
    if(!m_res->next()){
        delete m_stmt;
        delete m_res;
        return VerificationStatus::DNE;
    }
    
    delete m_stmt;
    if( m_res->getUInt("code") == atoi(code.c_str())){
        vs = VerificationStatus::SUCCESS;
        
        m_stmt = m_conn->prepareStatement("DELETE FROM reg WHERE email=?");
        m_stmt->setString(1,user);
        m_stmt->executeUpdate();
        delete m_stmt;
        delete m_res;
        
        createUser(user,pass); 
    }else{
        m_tries = m_res->getInt("tries");
        if(--m_tries == 0){
            vs = VerificationStatus::RENEW;
            RAND_bytes((unsigned char*)&m_code,sizeof(m_code));
            m_tries = 5;
            
            Email *e = new Email();
            bool good = e->sendCode(user,std::to_string(m_code));
            delete e;
            
            m_stmt = m_conn->prepareStatement("UPDATE reg SET code=?, tries='5' WHERE email=?");
            m_stmt->setUInt(1,(unsigned int)m_code);
            m_stmt->setString(2,user);
            m_stmt->executeUpdate();
        }else{
            vs = VerificationStatus::FAILURE;
            
            m_stmt = m_conn->prepareStatement("UPDATE reg SET tries=? WHERE email=?");
            m_stmt->setInt(1,m_tries);
            m_stmt->setString(2,user);
            m_stmt->executeUpdate();
        }
        delete m_stmt;
        delete m_res;
    }
    
    return vs;
}

void Database::remove(std::string user)
{
    m_stmt = m_conn->prepareStatement("DELETE FROM reg WHERE email=?");
    m_stmt->setString(1,user);
    m_stmt->executeUpdate();
    delete m_stmt;
}

std::string Database::getSession()
{
    std::string str;
    Utility::bytesToBase64(m_session,32,str);
    return str;
}

std::string Database::getCode()
{
    return std::to_string(m_code);
}

std::string Database::getTries()
{
    return std::to_string(m_tries);
}

