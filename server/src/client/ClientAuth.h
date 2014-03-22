#ifndef _CLIENT_AUTH_H_
#define _CLIENT_AUTH_H_

class Client;

#include <string>

#include <json/json.h>
#include "ClientResponder.h"

class ClientAuth : public ClientResponder {
public:
    ClientAuth();
    virtual ~ClientAuth();
    
    virtual void add(Client *c);
    virtual void remove(Client *c);
    virtual void run(Client *c, Json::Value &val);
    
private:
    void login(Client *c, Json::Value &val);
    void reg(Client *c, Json::Value &val);
    void close(Client *c, Json::Value &val);
    void verify(Client *c, Json::Value &val);
    Json::Value MESSAGE_AUTH, MESSAGE_AUTH_TRUE, MESSAGE_AUTH_FALSE, MESSAGE_AUTH_DB, MESSAGE_AUTH_CLOSED;
};

#endif /*_CLIENT_AUTH_H_*/