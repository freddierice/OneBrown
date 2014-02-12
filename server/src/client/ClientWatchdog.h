#ifndef _CLIENT_WATCHDOG_H_
#define _CLIENT_WATCHDOG_H_

#include <iostream>
#include <mutex>
#include <thread>
#include <vector>
#include <future>

#include "Client.h"

#include "../runner/Runner.h"

class Server;
class ClientWatchdog : public Runner {
public:
    ClientWatchdog();
    ~ClientWatchdog();
    
    void addClient(Client *c);
    void killClient(Client *c);
    void reauthClient(Client *c);
    
private:
    virtual void runner();
    
    std::mutex m_clientsM;
    std::vector<Client*> m_clients;
};

#endif /*_CLIENT_WATCHDOG_H_*/