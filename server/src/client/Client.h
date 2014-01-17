
#ifndef _CLIENT_H_
#define _CLIENT_H_

#include <iostream>
#include <thread>
#include <atomic>
#include <vector>

#include <json/json.h>

#include "../network/Network.h"

enum class ClientStatus : int {DEAD=0,NOT_AUTHORIZED,AUTHORIZED};

class Client{
public:
    Client(int sd);
    ~Client();
    
    void start();
    void close();
    
    ClientStatus getStatus();
    
private:
    Client();
    void run();
    
    Network *m_network;
    std::thread m_thread;
    
    //threadsafe
    std::atomic<ClientStatus> m_cs;
};

#endif /* _CLIENT_H_ */
 
