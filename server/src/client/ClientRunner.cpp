#include "ClientRunner.h"

#include "Client.h"

ClientRunner::ClientRunner(){}
ClientRunner::~ClientRunner(){}

void ClientRunner::add(Client *c)
{
    c->setResponder(this);
}

void ClientRunner::remove(Client *c)
{
    
}

void ClientRunner::run(Client *c, Json::Value &val)
{
    
}
