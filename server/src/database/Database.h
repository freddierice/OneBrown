#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <iostream>
#include <string>

#include "../utilities/Utility.h"

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>


class Database {
public:
    Database();
    ~Database();
    
    bool login(std::string user, std::string pass);
    
private:
    sql::Driver *m_driver;
    sql::Connection *m_conn;
    sql::Statement *m_stmt;
    sql::ResultSet *m_res;
};

#endif