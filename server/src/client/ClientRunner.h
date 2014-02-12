#ifndef _CLIENT_RUNNER_H_
#define _CLIENT_RUNNER_H_

#include <iostream>

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