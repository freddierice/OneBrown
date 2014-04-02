#include "ClientRunner.h"

#include "Client.h"
#include "Server.h"
#include "ClientWatchdog.h"
#include "ClientAuth.h"

ClientRunner::ClientRunner()
{
    MESSAGE_CMD["message"] = "cmd";
}

ClientRunner::~ClientRunner(){}

void ClientRunner::add(Client *c)
{
    c->setResponder(this,MESSAGE_CMD);
}

void ClientRunner::remove(Client *c)
{
    
}

void ClientRunner::run(Client *c, Json::Value &val)
{
    std::string msg;
    
    msg = val.get("message","").asString();
    
    if(msg == "close")
        close(c,val);
    else
        val = MESSAGE_INVALID;
}

void ClientRunner::logoff( Client *c, Json::Value &val )
{
    std::async(std::launch::async,&ClientAuth::add,Server::getInstance()->getAuth(),c);
    val = MESSAGE_EMPTY;
}

void ClientRunner::close( Client *c, Json::Value &val )
{
    std::async(std::launch::async,&ClientWatchdog::killClient,Server::getInstance()->getWatchdog(),c);
    val = MESSAGE_EMPTY;
}