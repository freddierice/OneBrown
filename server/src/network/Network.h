#ifndef _NETWORK_H_
#define _NETWORK_H_

#include <iostream>
#include <thread>
#include <mutex>
#include <atomic>
#include <chrono>

#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <openssl/bio.h>

#include <json/json.h>

#define BUF_SIZE 1024

class Network {
public:
    Network(BIO *sock);
    ~Network();
    
    Json::Value recvJSON();
    void sendJSON(Json::Value val);
    
    void sendBytes(const char *buf, size_t len);
    
    void start();
    void close();
    
private:
    Network();
    void recvBytes();
    
    BIO *m_sock;
    
    std::vector<Json::Value> m_jsonValues;
    std::mutex m_jsonValuesM;
    std::atomic<bool> m_isRunning;
};

#endif /* _NETWORK_H_ */