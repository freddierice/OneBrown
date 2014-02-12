#ifndef _CLIENT_RESPONDER_H_
#define _CLIENT_RESPONDER_H_

#include <iostream>

#include <json/json.h>

#include "Client.h"

class ClientResponder {
public:
    ClientResponder();
    virtual ~ClientResponder();
    
    virtual void add(Client *c) = 0;
    virtual void remove(Client *c) = 0;
    virtual void run(Client *c, Json::Value &val) = 0;

protected:
    Json::Value MESSAGE_INVALID;
};

#endif