#include "Network.h"

Network::Network(){}

Network::Network(BIO *sock)
{
    m_sock = sock;
}

Network::~Network()
{
    
}

void Network::sendJSON(Json::Value &val)
{
    std::string msg = m_writer.write(val);
    sendBytes(msg.c_str(),msg.length());
}

bool Network::recvJSON(Json::Value &val)
{
    m_jsonValuesM.lock();
    if( m_jsonValues.empty() ){
        m_jsonValuesM.unlock();
        return false;
    }
    val = m_jsonValues.front();
    m_jsonValues.pop();
    m_jsonValuesM.unlock();
    return true;
}

void Network::sendBytes(const char *buf, size_t len)
{
    BIO_write(m_sock,buf,len);
}

void Network::starter()
{
    r_buf = new char[BUF_SIZE];
    r_par = 0;
}

void Network::runner()
{
    if(r_par == 0){
        r_str = "";
    }
    r_len = BIO_read(m_sock, (void *)r_buf, BUF_SIZE);
    if(r_len <= 0){
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
        return;
    }
    r_i = 0;
    if(r_par == 0){
        while(r_buf[r_i] != '{' && r_i < r_len )
            ++r_i;
    }
    for(; r_i < r_len; ++r_i){
        if(r_buf[r_i] == '{')
            ++r_par;
        if(r_buf[r_i] == '}')
            --r_par;
        r_str.append(&r_buf[r_i], 1);
        if(r_par == 0){
            Json::Value val;
            if(r_reader.parse(r_str,val,false) && !val.isNull()){
                m_jsonValuesM.lock();
                m_jsonValues.push(val);
                m_jsonValuesM.unlock();
            }
            r_str = "";
        }
    }
}

void Network::ender()
{
    ::close(BIO_get_fd(m_sock,BIO_NOCLOSE));
    BIO_free_all(m_sock);
}

