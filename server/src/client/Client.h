#ifndef _CLIENT_H_
#define _CLIENT_H_

class Network;
class Database;

class ClientResponder;
class ClientRunner;
class ClientConnector;
class ClientAuth;

#include <chrono> 
#include <thread>

#include <json/json.h>
#include "../runner/Runner.h"

class Client : public Runner {
public:
    Client(Network *network);
    ~Client();
    
    void detach();
    std::chrono::time_point<std::chrono::system_clock> getTime();
protected:
    void setResponder(ClientResponder *responder);
    void setResponder(ClientResponder *responder,Json::Value &val);
    void sendJSON(Json::Value &val);
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