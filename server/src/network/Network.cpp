#include "Network.h"

Network::Network(){}

Network::Network(int sd)
{
    m_sd = sd;
    m_running = false;
}

Network::~Network()
{
    
}

void Network::start()
{
    if(!m_running){
        m_running = true;
        m_t = std::thread(&Network::recvBytes, this);
    }
}

void Network::sendJSON(Json::Value val)
{
    
}

Json::Value Network::recvJSON()
{
    Json::Value val;
    int s;
    
    m_jsonValuesM.lock();
    s = m_jsonValues.size();
    m_jsonValuesM.unlock();
    while( s == 0){
        std::this_thread::sleep_for(std::chrono::microseconds(100));
        m_jsonValuesM.lock();
        s = m_jsonValues.size();
        if(s == 0)
            m_jsonValuesM.unlock();
    }
    
    val = m_jsonValues.at(0);
    m_jsonValues.erase(m_jsonValues.begin());
    m_jsonValuesM.unlock();
    return val;
}

void Network::sendBytes(const char *buf, size_t len)
{
    send(m_sd, buf, len, 0);
}

void Network::recvBytes()
{
    Json::Reader reader;
    std::string str;
    char *buf;
    int len, par, i;
    
    buf = new char[BUF_SIZE];
    par = 0;
    while(m_running){
        if(par == 0){
            str = "";
        }
        len = recv(m_sd, buf, BUF_SIZE, 0);
        if(len <= 0){
            std::this_thread::sleep_for(std::chrono::microseconds(100));
            continue;
        }
        i = 0;
        if(par == 0){
            while(buf[i] != '{' && i < len )
                ++i;
        }
        for(; i < len; ++i){
            if(buf[i] == '{')
                ++par;
            if(buf[i] == '}')
                --par;
            str.append(&buf[i], 1);
            if(par == 0){
                Json::Value val;
                ;
                if(reader.parse(str,val,false) && !val.isNull()){
                    m_jsonValuesM.lock();
                    m_jsonValues.push_back(val);
                    m_jsonValuesM.unlock();
                }
                str = "";
            }
        }
        
    }
}

void Network::close()
{
    if(m_running){
        m_running = false;
        m_t.join();
    }
}