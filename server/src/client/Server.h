#ifndef _SERVER_H_
#define _SERVER_H_

class ClientAuth;
class ClientConnector;
class ClientRunner;
class ClientWatchdog;

#include "../common.h"

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