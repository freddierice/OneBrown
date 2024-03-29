#include "Database.h"

Database::Database()
{
    try{
        m_driver = get_driver_instance();
        m_conn = m_driver->connect("tcp://54.200.186.84:3306","red","password");
        m_conn->setSchema("onebrown");
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        throw "Database could not construct due to database connection error.";
    }
    
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
    
    try{
        m_stmt.reset(m_conn->prepareStatement("SELECT * FROM users WHERE session=?"));
        m_stmt->setBlob(1,&sessionStream);
        m_res.reset(m_stmt->executeQuery());
        if(m_res->next()){
            m_id = m_res->getInt("id");
            m_email = m_res->getString("email");
            m_res->getBlob("session")->read(m_session,32);
            ls = LoginStatus::SUCCESS;
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
        m_stmt.reset(m_conn->prepareStatement("SELECT * FROM users WHERE email=?"));
        m_stmt->setString(1,user);
        m_res.reset(m_stmt->executeQuery());
        
        if(m_res->next()){
            m_id = m_res->getInt("id");
            m_email = m_res->getString("email");
            m_res->getBlob("hash")->read(m_hash,32);
            m_res->getBlob("salt")->read(m_salt,16);
            if(!m_res->getBlob("session")->read(m_session,32)){
                RAND_bytes((unsigned char *)m_session,32);
                DataBuf sessionBuffer((char *)m_session,32);
                std::istream sessionStream(&sessionBuffer);
                
                m_stmt.reset(m_conn->prepareStatement("UPDATE users SET session=? WHERE id=?"));
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
        return LoginStatus::DB_FAILURE;
    }
    
    delete message;
    
    return ls;
}

bool Database::logout(int i)
{
    try{
        m_stmt.reset(m_conn->prepareStatement("UPDATE users SET session=NULL WHERE id=?"));
        m_stmt->setInt(1,i);
        m_stmt->executeUpdate();
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        return false;
    }
    return true;
}

bool Database::createUser(std::string user, std::string pass)
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
    
    try{
        m_stmt.reset(m_conn->prepareStatement("INSERT INTO users (email,salt,hash) VALUES (?,?,?)"));
        m_stmt->setString(1,user);
        m_stmt->setBlob(2,&saltStream);
        m_stmt->setBlob(3,&hashStream);
        m_stmt->executeUpdate();
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        return false;
    }
    
    return true;
}

RegistrationStatus Database::reg(std::string user)
{
    RegistrationStatus rs;
    
    Utility::sqlClean(user);
    
    try{
        m_stmt.reset(m_conn->prepareStatement("SELECT * FROM users WHERE email=?"));
        m_stmt->setString(1,user);
        m_res.reset(m_stmt->executeQuery());
        
        if(m_res->next())
            rs = RegistrationStatus::EXISTS;
        else{
            m_stmt.reset(m_conn->prepareStatement("SELECT * FROM reg WHERE email=?"));
            m_stmt->setString(1,user);
            m_res.reset(m_stmt->executeQuery());
            if(m_res->next()){
                rs = RegistrationStatus::VERIFY;
                m_tries = m_res->getInt("tries");
            }else{
                RAND_bytes((unsigned char*)&m_code,sizeof(m_code));
                
                Email e;
                bool good = e.testUser(user);
                if(!good)
                    return RegistrationStatus::NOT_BROWN;
                
                int i;
                for(i = 0; i < 5 && !e.sendCode(user,std::to_string(m_code)); ++i)
                    std::this_thread::sleep_for(std::chrono::microseconds(1000));
                if(i == 5)
                    return RegistrationStatus::DB_FAILURE;
                m_stmt.reset(m_conn->prepareStatement("INSERT INTO reg(email,code) VALUES (?,?)"));
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
        return RegistrationStatus::DB_FAILURE;
    }
    
    return rs;
}

VerificationStatus Database::verify(std::string user, std::string pass, std::string code)
{
    VerificationStatus vs;
    try{
        m_stmt.reset(m_conn->prepareStatement("SELECT * FROM reg WHERE email=?"));
        m_stmt->setString(1,user);
        m_res.reset(m_stmt->executeQuery());
        if(!m_res->next()){
            return VerificationStatus::DNE;
        }
        
        if( m_res->getUInt("code") == atoi(code.c_str())){
            vs = VerificationStatus::SUCCESS;
            
            if(m_res->getInt("tries") != 0){
                m_stmt.reset(m_conn->prepareStatement("DELETE FROM reg WHERE email=?"));
                m_stmt->setString(1,user);
                m_stmt->executeUpdate();
            }else{
                return VerificationStatus::RENEW;
            }
            
            int i;
            for(i = 0; i<5 && !createUser(user,pass); ++i)
                std::this_thread::sleep_for(std::chrono::microseconds(1000));
            if(i == 5)
                return VerificationStatus::DB_FAILURE;
        }else{
            m_tries = m_res->getInt("tries");
            if(--m_tries == 0){
                vs = VerificationStatus::RENEW;
                
                m_stmt.reset(m_conn->prepareStatement("UPDATE reg SET tries='0' WHERE email=?"));
                m_stmt->setString(1,user);
                m_stmt->executeUpdate();
            }else{
                vs = VerificationStatus::FAILURE;
                
                m_stmt.reset(m_conn->prepareStatement("UPDATE reg SET tries=? WHERE email=?"));
                m_stmt->setInt(1,m_tries);
                m_stmt->setString(2,user);
                m_stmt->executeUpdate();
            }
        }
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        return VerificationStatus::DB_FAILURE;
    }
    
    return vs;
}

bool Database::renew(std::string user)
{
    Email e;
    int i;
    
    RAND_bytes((unsigned char*)&m_code,sizeof(m_code));
    m_tries = 5;
    
    for(i = 0; i<5 && !e.sendCode(user,std::to_string(m_code)); ++i)
        std::this_thread::sleep_for(std::chrono::microseconds(1000));
    if(i == 5)
        return false;
    
    try{
        m_stmt.reset(m_conn->prepareStatement("UPDATE reg SET code=?, tries='5' WHERE email=?"));
        m_stmt->setUInt(1,(unsigned int)m_code);
        m_stmt->setString(2,user);
        m_stmt->executeUpdate();
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        return false;
    }
    return true;
}

bool Database::remove(std::string user)
{
    try{
        m_stmt.reset(m_conn->prepareStatement("DELETE FROM reg WHERE email=?"));
        m_stmt->setString(1,user);
        m_stmt->executeUpdate();
        
        m_stmt.reset(m_conn->prepareStatement("DELETE FROM users WHERE email=?"));
        m_stmt->setString(1,user);
        m_stmt->executeUpdate();
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        return false;
    }
    return true;
}

std::string Database::getSession()
{
    std::string str;
    Utility::bytesToBase64(m_session,32,str);
    return str;
}

std::string Database::getId()
{
    return std::to_string(m_id);
}

std::string Database::getCode()
{
    return std::to_string(m_code);
}

std::string Database::getTries()
{
    return std::to_string(m_tries);
}

std::string Database::getEmail()
{
    return m_email;
}