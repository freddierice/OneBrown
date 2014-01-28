#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <iostream>
#include <string>
#include <cstring>

#include "../utilities/Utility.h"
#include "../email/Email.h"

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

#include <openssl/rand.h>


enum class RegistrationStatus : int {SUCCESS=0,FAILURE,EXISTS,VERIFY,NOT_BROWN,DB_FAILURE};
enum class LoginStatus : int {SUCCESS=0,FAILURE,DB_FAILURE};
enum class VerificationStatus : int {SUCCESS=0,FAILURE,DNE,RENEW,DB_FAILURE};

class Database {
public:
    Database();
    ~Database();
    
    LoginStatus login(std::string session);
    LoginStatus login(std::string user, std::string pass);
    
    void createUser(std::string user, std::string pass);
    void logout();
    void remove(std::string user);
    void renew(std::string user);
    
    RegistrationStatus reg(std::string user);
    VerificationStatus verify(std::string user, std::string pass, std::string code);
    
    std::string getSession();
    std::string getCode();
    std::string getTries();
    
private:
    sql::Driver *m_driver;
    sql::Connection *m_conn;
    sql::ResultSet *m_res;
    
    sql::PreparedStatement *m_stmt;
    
    int m_id, m_tries;
    unsigned short m_code;
    std::string m_email;
    char *m_hash, *m_salt, *m_digest, *m_session;
};

#endif