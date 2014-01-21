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
            m_email = m_res->getString("email");
            m_res->getBlob("hash")->read(m_hash,32);
            m_res->getBlob("salt")->read(m_salt,16);
            
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

RegistrationStatus Database::reg(std::string user, std::string pass)
{
    RegistrationStatus rs;
    int pass_len;
    char *message;
    
    Utility::sqlClean(user);
    pass_len = pass.length();
    message = new char[pass_len+16];
    
    try{
        m_stmt = m_conn->prepareStatement("SELECT * FROM users WHERE email=?");
        m_stmt->setString(1,user);
        m_res = m_stmt->executeQuery();
        
        if(m_res->next())
            rs = RegistrationStatus::EXISTS;
        else{
            
            RAND_bytes((unsigned char*)m_salt,16);
            memcpy(message,pass.c_str(),pass_len);
            memcpy(message+pass_len,m_salt,16);
            Utility::sha256(message,16+pass_len,m_digest);
            
            DataBuf saltBuffer((char *)m_salt,16);
            DataBuf hashBuffer((char *)m_digest,32);
            std::istream saltStream(&saltBuffer);
            std::istream hashStream(&hashBuffer);
            
            delete m_stmt;
            m_stmt = m_conn->prepareStatement("INSERT INTO users (email,salt,hash) VALUES (?,?,?)");
            m_stmt->setString(1,user);
            m_stmt->setBlob(2,&saltStream);
            m_stmt->setBlob(3,&hashStream);
            m_stmt->executeUpdate();
        }
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
        rs = RegistrationStatus::DB_FAILURE;
    }
    
    delete message;
    delete m_stmt;
    delete m_res;
    
    return rs;
}

