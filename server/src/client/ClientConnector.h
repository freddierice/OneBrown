#ifndef _CLIENT_CONNECTOR_H_
#define _CLIENT_CONNECTOR_H_

class Server;
class Client;
class Network;

#include <future>

#include "../runner/Runner.h"

#define PORT 20000

class ClientConnector : public Runner {
public:
    ClientConnector();
    virtual ~ClientConnector();
    
private:
    virtual void runner();
    virtual void starter();
    virtual void ender();
    
    Client *r_c;
    Network *r_n;
    int r_sock, r_newsock;
};

#endif /*_CLIENT_CONNECTOR_H_*/