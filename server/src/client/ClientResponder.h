#ifndef _CLIENT_RESPONDER_H_
#define _CLIENT_RESPONDER_H_

class Client;

#include <json/json.h>

class ClientResponder {
public:
    ClientResponder();
    virtual ~ClientResponder();
    
    virtual void add(Client *c) = 0;
    virtual void remove(Client *c) = 0;
    virtual void run(Client *c, Json::Value &val) = 0;

protected:
    Json::Value MESSAGE_INVALID, MESSAGE_EMPTY;
};

#endif