#include "ClientWatchdog.h"

#include "Server.h"
#include "Client.h"

#include "ClientAuth.h"

ClientWatchdog::ClientWatchdog(){}
ClientWatchdog::~ClientWatchdog(){}

void ClientWatchdog::runner()
{
    r_now = std::chrono::system_clock::now();
    m_clientsM.lock();
    for(auto iter = m_clients.begin(); iter != m_clients.end(); ++iter)
        if(std::chrono::duration_cast<std::chrono::minutes>( r_now - (*iter)->getTime()).count() >= 120){
            std::async(std::launch::async,&ClientWatchdog::killClient,this,*iter);
            iter = m_clients.erase(iter);
        }
    m_clientsM.unlock();
}

void ClientWatchdog::addClient(Client *c)
{
    m_clientsM.lock();
    m_clients.push_back(c);
    m_clientsM.unlock();
}

void ClientWatchdog::killClient(Client *c)
{
    c->stop(true);
    delete c;
}

void ClientWatchdog::reauthClient(Client *c)
{
    c->detach();
    Server::getInstance()->getAuth()->add(c);
}