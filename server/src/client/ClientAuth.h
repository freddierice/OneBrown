#ifndef _CLIENT_AUTH_H_
#define _CLIENT_AUTH_H_

#include "ClientResponder.h"
#include "../database/Database.h"

class ClientAuth : public ClientResponder {
public:
    ClientAuth();
    virtual ~ClientAuth();
    
    virtual void add(Client *c);
    virtual void remove(Client *c);
    virtual void run(Client *c, Json::Value &val);
    
private:
    Database *m_database;
    Json::Value MESSAGE_AUTH, MESSAGE_AUTH_TRUE, MESSAGE_AUTH_FALSE;
};

#endif /*_CLIENT_AUTH_H_*/