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
    MESSAGE_AUTH_DB["message"] = "db_failure";
    MESSAGE_AUTH_CLOSED["message"] = "closed";
}

ClientAuth::~ClientAuth(){}


void ClientAuth::add(Client *c)
{
    c->setResponder(this);
    c->sendJSON(MESSAGE_AUTH);
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
    
    c->sendJSON(val);
}

void ClientAuth::reg(Client *c, Json::Value &val)
{
    
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
            val.clear();
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
    
}

void ClientAuth::close(Client *c, Json::Value &val)
{
    val = MESSAGE_AUTH_CLOSED;
}
