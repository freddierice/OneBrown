#include "Client.h"

Client::Client(){}

Client::Client(int sd)
{
    m_network = new Network(sd);
    m_database = new Database();
    m_cs = ClientStatus::DEAD;
    m_isRunning = false;
}

Client::~Client()
{
    delete m_network;
    delete m_database;
}

void Client::start()
{
    if(!m_isRunning){
        m_cs = ClientStatus::NOT_AUTHORIZED;
        m_isRunning = true;
        m_network->start();
        m_thread = std::thread(&Client::run,this);
    }
}

void Client::run()
{
    std::string msg;
    Json::Value val;
    
    std::cout << "Client connected\n";
    
    while(m_cs != ClientStatus::DEAD){
        authorize();
        while(m_cs == ClientStatus::AUTHORIZED)
        {
            msg = "";
            val.clear();
            while(msg == ""){
                val["message"] = "cmd";
                msg = m_writer.write(val);
                m_network->sendBytes(msg.c_str(),msg.length());
                val = m_network->recvJSON();
                msg = val.get("message","").asString();
            }
        
            if(msg == "logout")
                logout(val);
            else if(msg == "close")
                m_cs = ClientStatus::DEAD;
        }
    }
    
    m_network->close();
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
        else if(msg == "register")
            reg(val);
        else if(msg == "verify")
            verify(val);
        else if(msg == "remove")
            m_database->remove(val.get("user","user").asString());
        else if(msg == "renew")
            m_database->renew(val.get("user","user").asString());
        else if(msg == "close")
            m_cs = ClientStatus::DEAD;
    }
}

void Client::login(Json::Value &val)
{
    std::string user,pass,msg,ses;
    bool authorized;
    
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    ses  = val.get("session","").asString();
    val.clear();
    
    if(ses != "")
        authorized = m_database->login(ses) == LoginStatus::SUCCESS;
    else
        authorized = m_database->login(user,pass) == LoginStatus::SUCCESS;
    
    if(authorized){
        m_cs = ClientStatus::AUTHORIZED;
        val["message"] = "success";
        val["session"] = m_database->getSession();
    }else{
        val["message"] = "failure";
    }
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::reg(Json::Value &val)
{
    RegistrationStatus status;
    std::string user,msg;
    
    user = val.get("user","").asString();
    val.clear();
    
    status = m_database->reg(user);
    
    if( status == RegistrationStatus::SUCCESS)
        val["message"] = "success";
    else if(status == RegistrationStatus::EXISTS)
        val["message"] = "exists";
    else if(status == RegistrationStatus::NOT_BROWN)
        val["message"] = "not_brown";
    else if(status == RegistrationStatus::VERIFY){
        val["message"] = "verify";
        val["tries"] = m_database->getTries();
    }else
        val["message"] = "failure";
    
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::verify(Json::Value &val)
{
    std::string code,user,pass,msg;
    VerificationStatus vs;
    
    code = val.get("code","").asString();
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    val.clear();
    
    if(code == "" || user == "" || pass == "")
        val["message"] = "failure";
    else{
        vs = m_database->verify(user,pass,code);
        if(vs == VerificationStatus::SUCCESS)
            val["message"] = "success";
        else if(vs == VerificationStatus::DNE)
            val["message"] = "dne";
        else if(vs == VerificationStatus::RENEW)
            val["message"] = "renew";
        else{
            val["message"] = "failure";
            val["tries"] = m_database->getTries();
        }
    }
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::logout(Json::Value &val)
{
    m_database->logout();
    m_cs = ClientStatus::NOT_AUTHORIZED;
}

bool Client::close()
{
    if(m_isRunning){
        m_isRunning = false;
        m_thread.join();
        return true;
    }else
        return false;
}

ClientStatus Client::getStatus(){ return m_cs; }
bool Client::isRunning(){return m_isRunning;}