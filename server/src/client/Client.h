#ifndef _CLIENT_H_
#define _CLIENT_H_

#include <atomic>
#include <thread>
#include <chrono>

#include <json/json.h>

#include "../network/Network.h"
#include "../runner/Runner.h"
#include "../database/Database.h"

class ClientResponder;
class ClientAuth;
class ClientRunner;
class ClientConnector;

class Client : public Runner {
public:
    Client(Network *network);
    ~Client();
    
    void detach();
    std::chrono::time_point<std::chrono::system_clock> getTime();
protected:
    void setResponder(ClientResponder *responder);
    void setResponder(ClientResponder *responder,Json::Value &val);
    Database *m_database;
    
    friend ClientResponder;
    friend ClientAuth;
    friend ClientConnector;
    friend ClientRunner;
    
private:
    Client();
    virtual void runner();
    virtual void ender();
    
    Json::Value r_val;
    
    ClientResponder *m_responder;
    Network *m_network;
    std::chrono::time_point<std::chrono::system_clock> m_time;
};

#endif /*_CLIENT_H_*/