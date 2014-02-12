#ifndef _NETWORK_H_
#define _NETWORK_H_

#include <iostream>
#include <thread>
#include <mutex>
#include <atomic>
#include <chrono>
#include <queue>

#include <string.h>
#include <unistd.h>

#include <openssl/bio.h>

#include <json/json.h>

#include "../runner/Runner.h"

#define BUF_SIZE 1024

class Network : public Runner {
public:
    Network(BIO *sock);
    ~Network();
    
    bool recvJSON(Json::Value &val);
    void sendJSON(Json::Value &val);
    void sendBytes(const char *buf, size_t len);
    
    
private:
    Network();
    void recvBytes();
    virtual void starter();
    virtual void runner();
    virtual void ender();
    
    Json::Reader r_reader;
    std::string r_str;
    char *r_buf;
    int r_len, r_par, r_i;
    
    BIO *m_sock;
    Json::FastWriter m_writer;
    std::queue<Json::Value> m_jsonValues;
    std::mutex m_jsonValuesM;
    std::atomic<bool> m_isRunning;
};

#endif /* _NETWORK_H_ */