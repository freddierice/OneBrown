
#ifndef _CLIENT_H_
#define _CLIENT_H_

#include <iostream>
#include <thread>
#include <atomic>
#include <vector>

#include <json/json.h>

#include "../network/Network.h"
#include "../utilities/Utility.h"
#include "../database/Database.h"

enum class ClientStatus : int {DEAD=0,NOT_AUTHORIZED,AUTHORIZED};

class Client{
public:
    Client(int sd);
    ~Client();
    
    void start();
    void close();
    
    void authorize();
    void login(Json::Value &val);
    void reg(Json::Value &val);
    
    ClientStatus getStatus();
    
private:
    Client();
    void run();
    
    Json::FastWriter m_writer;
    
    Network *m_network;
    Database *m_database;
    std::thread m_thread;
    
    std::atomic<ClientStatus> m_cs;
};

#endif /* _CLIENT_H_ */
 
