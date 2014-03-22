#include "Server.h"

#include "ClientAuth.h"
#include "ClientConnector.h"
#include "ClientRunner.h"
#include "ClientWatchdog.h"

Server* Server::m_instance = NULL;

Server::Server()
{
    m_auth = new ClientAuth();
    m_connector = new ClientConnector();
    m_runner = new ClientRunner();
    m_watchdog = new ClientWatchdog();
}

Server::~Server()
{
    delete m_auth;
    delete m_connector;
    delete m_runner;
    delete m_watchdog;
}

Server* Server::getInstance()
{
    if(m_instance == NULL)
        m_instance = new Server();
    return m_instance;
}

ClientAuth* Server::getAuth(){ return m_auth; }
ClientConnector* Server::getConnector(){ return m_connector; }
ClientRunner* Server::getRunner(){ return m_runner; }
ClientWatchdog* Server::getWatchdog(){ return m_watchdog; }