#include "Database.h"

Database::Database()
{
    m_driver = get_driver_instance();
    m_conn = m_driver->connect("tcp://127.0.0.1:3306","root","df9qfEZVoXl/8MW4");
    m_conn->setSchema("onebrown");
}

Database::~Database()
{
    
}

bool Database::login(std::string user, std::string pass)
{
    Utility::sqlClean(user);
    
    m_stmt = m_conn->createStatement();
    m_res = m_stmt->executeQuery("SELECT * FROM users WHERE user = '" + user + "'");
}

