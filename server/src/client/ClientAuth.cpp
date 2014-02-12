#include "ClientAuth.h"

ClientAuth::ClientAuth()
{
    m_database = new Database();
    MESSAGE_AUTH["message"] = "auth";
    MESSAGE_AUTH_TRUE["message"] = "success";
    MESSAGE_AUTH_FALSE["message"] = "failed";
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
    std::string msg = val.get("message","").asString();
    if(msg == "login"){
        std::string session = val.get("session","").asString();
        std::string user = val.get("user","").asString();
        std::string pass = val.get("pass","").asString();
        if( session != "" )
            m_database->login(session);
        else if(pass != "" && user != "")
            m_database->login(user,pass);
    }else if(msg == ""){
        val = MESSAGE_INVALID;
    }
    
}