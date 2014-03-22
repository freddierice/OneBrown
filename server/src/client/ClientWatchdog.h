#ifndef _CLIENT_WATCHDOG_H_
#define _CLIENT_WATCHDOG_H_

#include <mutex>
#include <future>
#include <thread>
#include <chrono>
#include <vector>

class Client;

#include "../runner/Runner.h"

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