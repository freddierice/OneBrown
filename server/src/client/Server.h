#ifndef _SERVER_H_
#define _SERVER_H_

#include "ClientAuth.h"
#include "ClientConnector.h"
#include "ClientRunner.h"
#include "ClientWatchdog.h"

class Server {
public:
    static Server* getInstance();

    ClientAuth *getAuth();
    ClientConnector *getConnector();
    ClientRunner *getRunner();
    ClientWatchdog *getWatchdog();
private:
    Server();
    ~Server();
    
    ClientAuth *m_auth;
    ClientConnector *m_connector;
    ClientRunner *m_runner;
    ClientWatchdog *m_watchdog;
    
    static Server *m_instance;
};

#endif /*_SERVER_H_*/