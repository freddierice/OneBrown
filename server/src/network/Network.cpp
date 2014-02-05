#include "Network.h"

Network::Network(){}

Network::Network(BIO *sock)
{
    m_sock = sock;
    m_isRunning = false;
}

Network::~Network()
{
    
}

void Network::start()
{
    if(!m_isRunning){
        m_isRunning = true;
        std::thread t(&Network::recvBytes, this);
        t.detach();
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
    while( s == 0 && m_isRunning){
        std::this_thread::sleep_for(std::chrono::microseconds(1000));
        m_jsonValuesM.lock();
        s = m_jsonValues.size();
        if(s == 0)
            m_jsonValuesM.unlock();
    }
    
    if(!m_isRunning){
        return val;
    }
    
    val = m_jsonValues.at(0);
    m_jsonValues.erase(m_jsonValues.begin());
    m_jsonValuesM.unlock();
    return val;
}

void Network::sendBytes(const char *buf, size_t len)
{
    BIO_write(m_sock,buf,len);
}

void Network::recvBytes()
{
    Json::Reader reader;
    std::string str;
    char *buf;
    int len, par, i;
    
    buf = new char[BUF_SIZE];
    par = 0;
    while(m_isRunning){
        if(par == 0){
            str = "";
        }
        len = BIO_read(m_sock, (void *)buf, BUF_SIZE);
        if(len <= 0){
            std::this_thread::sleep_for(std::chrono::microseconds(1000));
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
    i = BIO_get_fd(m_sock,BIO_NOCLOSE);
    BIO_free_all(m_sock);
    ::close(i);
}

void Network::close()
{
    if(m_isRunning){
        m_isRunning = false;
    }
}