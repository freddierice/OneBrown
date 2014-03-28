#ifndef _CLIENT_RUNNER_H_
#define _CLIENT_RUNNER_H_

class Client;

#include <future>

#include <json/json.h>
#include "ClientResponder.h"

class ClientRunner : public ClientResponder {
public:
    ClientRunner();
    virtual ~ClientRunner();
    
    virtual void add(Client *c);
    virtual void remove(Client *c);
    virtual void run(Client *c, Json::Value &val);

private:
    void logoff( Client *c, Json::Value &val );
    void close( Client *c, Json::Value &val );
    
    Json::Value MESSAGE_CMD;
};

#endif /*_CLIENT_RUNNER_H_*/