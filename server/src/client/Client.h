
#ifndef _CLIENT_H_
#define _CLIENT_H_

#include <iostream>
#include <thread>
#include <atomic>
#include <vector>
#include <chrono>
#include <mutex>

#include <json/json.h>

#include "ClientCollector.h"
#include "Cache.h"
#include "../network/Network.h"
#include "../utilities/Utility.h"
#include "../database/Database.h"

enum class ClientStatus : int {DEAD=0,NOT_AUTHORIZED,AUTHORIZED};

class ClientCollector;
class Client{
public:
    Client(BIO *sock, ClientCollector *cc);
    ~Client();
    
    void start();
    void reinit(BIO *sock);
    bool close();
    
    ClientStatus getStatus();
    bool isRunning();
    
    Cache* getCache();
    void setCache(Cache *c);
    std::string getSession();
    std::chrono::time_point<std::chrono::system_clock> getTime();
    
private:
    Client();
    void run();
    
    void authorize();
    void login(Json::Value &val);
    void logout(Json::Value &val);
    void reg(Json::Value &val);
    void verify(Json::Value &val);
    void renew(Json::Value &val);
    void remove(Json::Value &val);
    void close(Json::Value &val);
    
    void initializeCache();
    
    Json::FastWriter m_writer;
    bool m_hashed;
    
    ClientCollector *m_cc;
    Cache *m_cache;
    Network *m_network;
    Database *m_database;
    std::thread m_thread;
    std::string m_session;
    std::chrono::time_point<std::chrono::system_clock> m_time;
    
    std::atomic<ClientStatus> m_cs;
    std::atomic<bool> m_isRunning;
};

#endif /* _CLIENT_H_ */
 
