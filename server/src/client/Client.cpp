#include "Client.h"

Client::Client(){}

Client::Client(int sd)
{
    m_network = new Network(sd);
    m_database = new Database();
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
    Json::Value val;
    while(m_cs == ClientStatus::NOT_AUTHORIZED){
        msg = "";
        val.clear();
        while(msg == ""){
            val["message"] = "login_or_register";
            msg = m_writer.write(val);
            m_network->sendBytes(msg.c_str(),msg.length());
            val = m_network->recvJSON();
            msg = val.get("message","").asString();
        }
        
        if(msg == "login")
            login(val);
        if(msg == "register")
            reg(val);
    }
}

void Client::login(Json::Value &val)
{
    std::string user,pass,msg,ses;
    
    std::cout << "Logging in..." << std::endl;
    
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    val.clear();
    
    if(m_database->login(user,pass) == LoginStatus::SUCCESS){
        std::cout << "Yay!" << std::endl;
        m_cs = ClientStatus::AUTHORIZED;
        val["message"] = "success";
        val["session"] = m_database->getSession();
    }else{
        std::cout << "Aww!" << std::endl;
        val["message"] = "failure";
    }
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::reg(Json::Value &val)
{
    std::string user,pass;
    
    std::cout << "Registering..." << std::endl;
    
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    
    m_database->reg(user,pass);
}

void Client::close()
{
    if(m_cs != ClientStatus::DEAD){
        m_thread.join();
        m_cs = ClientStatus::DEAD;
    }
}

ClientStatus Client::getStatus(){ return m_cs; }