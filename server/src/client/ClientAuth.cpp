#include "ClientAuth.h"

#include "Client.h"
#include "Server.h"
#include "../database/Database.h"
#include "ClientRunner.h"

ClientAuth::ClientAuth()
{
    MESSAGE_AUTH["message"] = "auth";
    MESSAGE_AUTH_TRUE["message"] = "success";
    MESSAGE_AUTH_FALSE["message"] = "failed";
    MESSAGE_AUTH_EXISTS["message"] = "exists";
    MESSAGE_AUTH_VERIFY["message"] = "verify";
    MESSAGE_AUTH_RENEW["message"] = "renew";
    MESSAGE_AUTH_DNE["message"] = "dne";
    MESSAGE_AUTH_NOT_BROWN["message"] = "not_brown";
    MESSAGE_AUTH_DB["message"] = "db_failure";
    MESSAGE_AUTH_CLOSED["message"] = "closed";
}

ClientAuth::~ClientAuth(){}


void ClientAuth::add(Client *c)
{
    c->setResponder(this,MESSAGE_AUTH);
}

void ClientAuth::remove(Client *c)
{
    
}

void ClientAuth::run(Client *c, Json::Value &val)
{
    std::string msg;
    
    msg = val.get("message","").asString();
    if(msg == "login")
        login(c,val);
    else if(msg == "reg")
        reg(c,val);
    else if(msg == "verify")
        verify(c,val);
    else if(msg == "close")
        close(c,val);
    else
        val = MESSAGE_INVALID;
    
    std::async(std::launch::async,&ClientAuth::add,Server::getInstance()->getAuth(),c);
}

void ClientAuth::reg(Client *c, Json::Value &val)
{
    RegistrationStatus status;
    std::string user,msg;
    
    user = val.get("user","").asString();
    
    if(user != "")
        status = c->m_database->reg(user);
    else
        status = RegistrationStatus::FAILURE;
    
    if( status == RegistrationStatus::SUCCESS)
        val = MESSAGE_AUTH_TRUE;
    else if(status == RegistrationStatus::EXISTS)
        val = MESSAGE_AUTH_EXISTS;
    else if(status == RegistrationStatus::NOT_BROWN)
        val = MESSAGE_AUTH_NOT_BROWN;
    else if(status == RegistrationStatus::VERIFY){
        val = MESSAGE_AUTH_VERIFY;
        val["tries"] = c->m_database->getTries();
    }else if(status == RegistrationStatus::DB_FAILURE)
        val = MESSAGE_AUTH_DB;
    else
        val = MESSAGE_AUTH_FALSE;
}

void ClientAuth::login(Client *c, Json::Value &val)
{
    std::string session, user, pass;
    LoginStatus ls;
    
    session = val.get("session","").asString();
    user    = val.get("user","").asString();
    pass    = val.get("pass","").asString();
    
    if( session != "" )
        ls = c->m_database->login(session);
    else if(pass != "" && user != "")
        ls = c->m_database->login(user,pass);
    else
        ls = LoginStatus::FAILURE;
    
    switch(ls){
        case LoginStatus::SUCCESS:
            Server::getInstance()->getRunner()->add(c);
            val = MESSAGE_AUTH_TRUE;
            break;
        case LoginStatus::FAILURE:
            val = MESSAGE_AUTH_FALSE;
            break;
        case LoginStatus::DB_FAILURE:
            val = MESSAGE_AUTH_DB;
            break;
    }
}

void ClientAuth::verify(Client *c, Json::Value &val)
{
    std::string code,user,pass,msg;
    VerificationStatus vs;
    
    code = val.get("code","").asString();
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    val.clear();
    
    if(code == "" || user == "" || pass == "")
        val = MESSAGE_AUTH_FALSE;
    else{
        vs = c->m_database->verify(user,pass,code);
        if(vs == VerificationStatus::SUCCESS)
            val = MESSAGE_AUTH_TRUE;
        else if(vs == VerificationStatus::DNE)
            val = MESSAGE_AUTH_DNE;
        else if(vs == VerificationStatus::RENEW)
            val = MESSAGE_AUTH_RENEW;
        else{
            val = MESSAGE_AUTH_FALSE;
            val["tries"] = c->m_database->getTries();
        }
    }
}

void ClientAuth::close(Client *c, Json::Value &val)
{
    //delay the deletion of c
    val = MESSAGE_AUTH_CLOSED;
}
