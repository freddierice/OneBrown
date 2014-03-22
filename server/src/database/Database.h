#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <iostream>
#include <thread>
#include <chrono>

#include <mysql_connection.h>
#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <cppconn/prepared_statement.h>

class Utility;
class Email;

enum class RegistrationStatus : int {SUCCESS=0,FAILURE,EXISTS,VERIFY,NOT_BROWN,DB_FAILURE};
enum class LoginStatus : int {SUCCESS=0,FAILURE,DB_FAILURE};
enum class VerificationStatus : int {SUCCESS=0,FAILURE,DNE,RENEW,DB_FAILURE};
            
class Database {
public:
    Database();
    ~Database();
    
    LoginStatus login(std::string session);
    LoginStatus login(std::string user, std::string pass);
    RegistrationStatus reg(std::string user);
    VerificationStatus verify(std::string user, std::string pass, std::string code);
    
    bool logout(int i);
    bool remove(std::string user);
    bool renew(std::string user);
    
    std::string getEmail();
    std::string getSession();
    std::string getCode();
    std::string getId();
    std::string getTries();
    
private:
    bool createUser(std::string user, std::string pass);
    
    sql::Driver *m_driver;
    sql::Connection *m_conn;
    std::unique_ptr<sql::ResultSet> m_res;
    std::unique_ptr<sql::PreparedStatement> m_stmt;
    
    int m_id, m_tries;
    unsigned short m_code;
    std::string m_email;
    char *m_hash, *m_salt, *m_digest, *m_session;
};
            
#endif