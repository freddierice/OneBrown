#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <iostream>
#include <string>
#include <cstring>

#include "../utilities/Utility.h"

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#include <openssl/rand.h>


enum class RegistrationStatus : int {SUCCESS=0,FAILURE,EXISTS,DB_FAILURE};
enum class LoginStatus : int {SUCCESS=0,FAILURE,DB_FAILURE};

class Database {
public:
    Database();
    ~Database();
    
    LoginStatus login(std::string session);
    LoginStatus login(std::string user, std::string pass);
    
    RegistrationStatus reg(std::string user, std::string pass);
    
    std::string getSession();
    
private:
    sql::Driver *m_driver;
    sql::Connection *m_conn;
    sql::ResultSet *m_res;
    
    sql::PreparedStatement *m_stmt;
    
    int m_id;
    std::string m_email;
    char *m_hash, *m_salt, *m_digest, *m_session;
};

#endif