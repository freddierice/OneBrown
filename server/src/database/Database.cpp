#include "Database.h"

Database::Database()
{
    m_driver = get_driver_instance();
    m_conn = m_driver->connect("tcp://54.200.186.84:3306","red","password");
    m_conn->setSchema("onebrown");
}

Database::~Database()
{
    
}

bool Database::login(std::string user, std::string pass)
{
    Utility::sqlClean(user);
    
    try{
        m_stmt = m_conn->createStatement();
        m_res = m_stmt->executeQuery("SELECT * FROM users WHERE email= '" + user + "'");
    
    
        if(m_res->next())
            std::cout << "success!" << std::endl;
        else
            std::cout << "failure." << std::endl;
        
    }catch (sql::SQLException e) {
        std::cout << "# ERR: SQLException in " << __FILE__;
        std::cout << "(" << __FUNCTION__ << ") on line " << __LINE__ << std::endl;
        std::cout << "# ERR: " << e.what();
        std::cout << " (MySQL error code: " << e.getErrorCode();
        std::cout << ", SQLState: " << e.getSQLState() << " )" << std::endl;
    }
    
    delete m_res;
    delete m_stmt;
}

