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
    authorize();
    
    m_cs = ClientStatus::DEAD;
}

void Client::authorize()
{
    std::string msg; 
    while(m_cs == ClientStatus::NOT_AUTHORIZED){
        msg = "";
        while(msg == ""){
            Json::Value val;
            val["message"] = "login_or_register";
            msg = m_writer.write(val);
            m_network->sendBytes(msg.c_str(),msg.length());
            val = m_network ->recvJSON();
            msg = val.get("message","").asString();
        }
        
        if(msg == "login")
            login();
        if(msg == "register")
            reg();
    }
}

void Client::login()
{
    std::cout << "Logging in..." << std::endl;
}

void Client::reg()
{
    std::cout << "Registering..." << std::endl;
}

void Client::close()
{
    if(m_cs != ClientStatus::DEAD){
        m_thread.join();
        m_cs = ClientStatus::DEAD;
    }
}

ClientStatus Client::getStatus(){ return m_cs; }