#include "Client.h"

Client::Client(){}

Client::Client(int sd)
{
    m_network = new Network(sd);
    m_cs = ClientStatus::DEAD;
}

Client::~Client()
{
    
}

void Client::start()
{
    if(m_cs == ClientStatus::DEAD){
        m_cs = ClientStatus::NOT_AUTHORIZED;
        m_thread = std::thread(&Client::run,this);
        m_network->start();
    }
}

void Client::run()
{
    std::cout << "Client connected\n";
    std::cout.flush();
    
    m_network->sendBytes("Hello there!\n",sizeof("Hello there!\n"));
    Json::Value val = m_network->recvJSON();
    std::cout << val["user"].asString() << std::endl;
    
    m_cs = ClientStatus::DEAD;
}

void Client::close()
{
    if(m_cs != ClientStatus::DEAD){
        m_thread.join();
        m_cs = ClientStatus::DEAD;
    }
}

ClientStatus Client::getStatus(){ return m_cs; }