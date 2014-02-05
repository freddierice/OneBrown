#include "Client.h"

Client::Client(){}

Client::Client(BIO *sock, ClientCollector *cc)
{
    m_cc = cc;
    m_network = new Network(sock);
    m_database = new Database();
    m_cs = ClientStatus::NOT_AUTHORIZED;
    m_isRunning = false;
    m_hashed = false;
}

Client::~Client()
{
    delete m_network;
    delete m_database;
}

void Client::start()
{
    if(!m_isRunning){
        m_isRunning = true;
        m_network->start();
        m_time = std::chrono::system_clock::now();
        m_thread = std::thread(&Client::run,this);
        m_thread.detach();
    }
}

void Client::reinit(BIO *sock)
{
    delete m_network;
    m_network = new Network(sock);
    m_cs = ClientStatus::AUTHORIZED;
    start();
}

void Client::run()
{
    std::string msg;
    Json::Value val;
    
    std::cout << "Client connected." << std::endl;
    while(m_isRunning){
        authorize();
        if(m_hashed)
           std::cout << "[" << m_cache->getValue("email") << "]" << " authorized." << std::endl;
        while(m_cs == ClientStatus::AUTHORIZED && m_isRunning)
        {
            msg = "";
            val.clear();
            while(msg == ""){
                val["message"] = "cmd";
                msg = m_writer.write(val);
                m_network->sendBytes(msg.c_str(),msg.length());
                m_time = std::chrono::system_clock::now();
                val = m_network->recvJSON();
                msg = val.get("message","").asString();
            }
        
            if(msg == "logout")
                logout(val);
            else if(msg == "close")
                close(val);
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
            m_time = std::chrono::system_clock::now();
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
            remove(val);
        else if(msg == "renew")
            renew(val);
        else if(msg == "close")
            close(val);
    }
    
    if(m_cs == ClientStatus::AUTHORIZED){
        if(!m_hashed){
            m_cc->getCache(this);
            if(m_cache == NULL){
                initializeCache();
                m_cc->hashCache(this);
            }
            m_hashed = true;
        }
    }
}

void Client::login(Json::Value &val)
{
    LoginStatus ls;
    std::string user,pass,msg,ses;
    bool authorized;
    
    user = val.get("user","").asString();
    pass = val.get("pass","").asString();
    ses  = val.get("session","").asString();
    val.clear();
    
    m_session = "";
    if(ses != ""){
        m_session = ses;
        m_cc->getCache(this);
        if(m_cache == NULL){
            ls = m_database->login(ses);
        }else{
            m_hashed = true;
            ls = LoginStatus::SUCCESS;
        }
    }else
        ls = m_database->login(user,pass);
    
    if(ls == LoginStatus::SUCCESS){
        m_cs = ClientStatus::AUTHORIZED;
        val["message"] = "success";
        if(m_session == ""){
            m_session = m_database->getSession();
            val["session"] = m_session;
        }
    }else if(ls == LoginStatus::DB_FAILURE)
        val["message"] = "db_failure";
    else
        val["message"] = "failure";
    
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
    }else if(status == RegistrationStatus::DB_FAILURE)
        val["message"] = "db_failure";
    else
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
    m_database->logout(atoi(m_cache->getValue("id").c_str()));
    m_cc->killCache(this);
    m_hashed = false;
    close(val);
}

void Client::renew(Json::Value &val)
{
    std::string user,msg;
    int i;
    
    user = val.get("user","").asString();
    val.clear();
    
    if(user == "")
        val["message"] = "failure";
    else{
        for(i = 0; i < 5 && !m_database->renew(user); ++i)
            std::this_thread::sleep_for(std::chrono::microseconds(1000));
        if(i == 5)
            val["message"] = "db_failure";
        else
            val["message"] = "success";
    }
    
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::remove(Json::Value &val)
{
    std::string user,msg;
    int i;
    
    user = val.get("user","").asString();
    val.clear();
    
    if(user == "")
        val["message"] = "failure";
    else{
        for(i = 0; i < 5 && !m_database->remove(user); ++i)
            std::this_thread::sleep_for(std::chrono::microseconds(1000));
        if(i == 5)
            val["message"] = "db_failure";
        else
            val["message"] = "success";
    }
    
    msg = m_writer.write(val);
    m_network->sendBytes(msg.c_str(),msg.length());
}

void Client::initializeCache()
{
    if(m_cache != NULL)
        delete m_cache;
    m_cache = new Cache();
    m_cache->setValue("email",m_database->getEmail());
    m_cache->setValue("id",m_database->getId());
}

void Client::close(Json::Value &val)
{
    m_cs = ClientStatus::DEAD;
    m_isRunning = false;
    if(m_hashed)
        std::cout << "[" << m_cache->getValue("email") << "]" << " closed session." << std::endl;
    else
        std::cout << "Client disconnected." << std::endl;
}

bool Client::close()
{
    if(m_isRunning){
        m_isRunning = false;
        return true;
    }else
        return false;
}

ClientStatus Client::getStatus(){ return m_cs; }
bool Client::isRunning(){return m_isRunning;}
std::string Client::getSession(){return m_session;}
std::chrono::time_point<std::chrono::system_clock> Client::getTime(){return m_time; }
Cache* Client::getCache(){return m_cache;}
void Client::setCache(Cache *c){m_cache = c;}