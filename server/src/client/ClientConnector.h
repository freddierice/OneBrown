#ifndef _CLIENT_CONNECTOR_H_
#define _CLIENT_CONNECTOR_H_
#include <iostream>
#include <future>

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

#include <netdb.h>
#include <netinet/in.h>

#include <openssl/bio.h>
#include <openssl/ssl.h>

#include "../network/Network.h"
#include "../runner/Runner.h"
#include "Client.h"

#define PORT 20000

class Server;
class ClientConnector : public Runner {
public:
    ClientConnector();
    virtual ~ClientConnector();
    
private:
    virtual void runner();
    virtual void starter();
    virtual void ender();
    
    Client *r_c;
    int r_sock, r_newsock;
};

#endif /*_CLIENT_CONNECTOR_H_*/