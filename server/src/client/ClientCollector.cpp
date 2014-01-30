#include "ClientCollector.h"

ClientCollector::ClientCollector()
{
    
}

void ClientCollector::start()
{
    m_thread = std::thread(&ClientCollector::run,this);
}

void ClientCollector::run()
{
    std::chrono::time_point<std::chrono::system_clock> now;
    while(true)
    {
        m_vecM.lock();
        m_hashM.lock();
        now = std::chrono::system_clock::now();
        for(auto it = m_unauthed_clients.begin(); it != m_unauthed_clients.end();)
            if(std::chrono::duration_cast<std::chrono::minutes>( now - (*it)->getTime()).count() >= 60){ //wait for 60 minutes
                (*it)->close();
                delete *it;
                it = m_unauthed_clients.erase(it);
            }else{
                ++it;
            }
        
        now = std::chrono::system_clock::now();
        for (auto it = m_hashmap.begin(); it != m_hashmap.end(); )
            if(std::chrono::duration_cast<std::chrono::minutes>(now - it->second->getTime()).count() >= 60){
                it->second->close();
                delete it->second;
                it = m_hashmap.erase(it);
            }else{
                ++it;
            }
        m_vecM.unlock();
        m_hashM.unlock();
        
        std::this_thread::sleep_for(std::chrono::minutes(10));
    }
}

void ClientCollector::addClient(BIO *sock)
{
    std::thread t(&ClientCollector::addClientP,this,sock);
    t.detach();
}

void ClientCollector::addClientP(BIO *sock)
{
    Client *c;
    try{
        c = new Client(sock,this);
    }catch( std::string str ){
        std::cout << "Error: " << str << std::endl;
    }
    m_vecM.lock();
    m_unauthed_clients.push_back(c);
    m_vecM.unlock();
    c->start();
}

void ClientCollector::hash(Client *c)
{
    std::thread t(&ClientCollector::hashP,this,c);
    t.detach();
}

void ClientCollector::hashP(Client *c)
{
    m_vecM.lock();
    std::vector<Client *>::iterator it;
    for(it = m_unauthed_clients.begin(); it != m_unauthed_clients.end(); ++it)
        if(*it == c){
            m_unauthed_clients.erase(it);
            break;
        }
    m_vecM.unlock();
    m_hashM.lock();
    m_hashmap.insert({c->getSession(),c});
    m_hashM.unlock();
}
