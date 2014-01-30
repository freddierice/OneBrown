#ifndef _CLIENT_COLLECTOR_H_
#define _CLIENT_COLLECTOR_H_

#include <iostream>
#include <thread>
#include <vector>
#include <chrono>
#include <mutex>
#include <unordered_map>

#include <stdlib.h>
#include <unistd.h>

#include "Client.h"

#include <openssl/bio.h>
#include <openssl/ssl.h>

class Client;
class ClientCollector{
public:
    ClientCollector();
    
    void start();
    
    void addClient(BIO *sock);
    void hash(Client *c);
    
private:
    void addClientP(BIO *sock);
    void hashP(Client *c);
    void run();
    
    std::thread m_thread;
    
    std::mutex m_vecM;
    std::mutex m_hashM;
    
    std::vector<Client *> m_unauthed_clients;
    std::unordered_map<std::string,Client *> m_hashmap;
};


#endif /*_CLIENT_COLLECTOR_H_*/