#include "Client.h"

#include "../database/Database.h"
#include "../network/Network.h"

#include "ClientResponder.h"


Client::Client(){}
Client::Client(Network *network)
{
    m_network = network;
    m_database = new Database();
}

Client::~Client()
{
    m_network->stop(true);
    delete m_network;
    delete m_database;
}

void Client::setResponder(ClientResponder *responder)
{
    m_responder = responder;
}

void Client::setResponder(ClientResponder *responder,Json::Value &val)
{
    m_responder = responder;
    m_network->sendJSON(val);
}

void Client::detach()
{
    if(m_responder)
        m_responder->remove(this);
    m_responder = NULL;
}

void Client::runner()
{
    m_time = std::chrono::system_clock::now();
    r_responder = m_responder;
    if(!r_responder){
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
        return;
    }
    
    if(m_network->recvJSON(r_val)){
        r_responder->run(this, r_val);
        if(r_val.size())
            m_network->sendJSON(r_val); 
    }else
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
}

void Client::sendJSON(Json::Value &val)
{
    m_network->sendJSON(val);
}

void Client::ender()
{
    if(m_responder)
        m_responder->remove(this);
}

std::chrono::time_point<std::chrono::system_clock> Client::getTime(){return m_time;}

