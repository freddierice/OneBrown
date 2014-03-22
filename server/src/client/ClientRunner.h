#ifndef _CLIENT_RUNNER_H_
#define _CLIENT_RUNNER_H_

class Client;

#include <json/json.h>
#include "ClientResponder.h"

class ClientRunner : public ClientResponder {
public:
    ClientRunner();
    virtual ~ClientRunner();
    
    virtual void add(Client *c);
    virtual void remove(Client *c);
    virtual void run(Client *c, Json::Value &val);
};

#endif /*_CLIENT_RUNNER_H_*/