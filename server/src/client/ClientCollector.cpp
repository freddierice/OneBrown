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
    std::string user;
    Cache *c;
    
    std::cout << "Entered ClientCollector::run" << std::endl;
    while(true)
    {
        m_vecM.lock();
        now = std::chrono::system_clock::now();
        for(auto it = m_unauthed_clients.begin(); it != m_unauthed_clients.end();)
            if(std::chrono::duration_cast<std::chrono::minutes>( now - (*it)->getTime()).count() >= 30){ //wait for 30 minutes
                c = (*it)->getCache();
                if(c)
                    user = c->getValue("email");
                else
                    user = "";
                (*it)->close();
                delete *it;
                it = m_unauthed_clients.erase(it);
                if(user == "")
                    std::cout << "Client instance removed." << std::endl;
                else
                    std::cout << "[" << user << "] " << "instance removed." << std::endl;
            }else{
                ++it;
            }
        m_vecM.unlock();
        
        //let the locks be absorbed by another process.
        std::this_thread::sleep_for(std::chrono::minutes(5));
    }
}

void ClientCollector::addClient(BIO *sock)
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

void ClientCollector::hashCache(Client *c)
{
    m_hashM.lock();
    m_hashmap[c->getSession()] = c->getCache();
    m_hashM.unlock();
}

void ClientCollector::getCache(Client *c)
{
    c->setCache(m_hashmap[c->getSession()]);
}

void ClientCollector::killCache(Client *c)
{
    Cache *cache;
    
    cache = m_hashmap[c->getSession()];
    if(cache != NULL){
        m_hashM.lock();
        m_hashmap.erase(c->getSession());
        m_hashM.unlock();
        std::this_thread::sleep_for(std::chrono::minutes(5));
        delete cache;
    }
}
