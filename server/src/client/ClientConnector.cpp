#include "ClientConnector.h"

#include "Server.h"
#include "Client.h"
#include "../network/Network.h"
#include "ClientWatchdog.h"
#include "ClientAuth.h"

ClientConnector::ClientConnector(){}
ClientConnector::~ClientConnector(){}

void ClientConnector::starter()
{
    struct sockaddr_in serv_addr;
    int iSetOption = 1;
    
    r_sock = socket(AF_INET, SOCK_STREAM, 0);
    
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(PORT);
    
    if (::bind(r_sock, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
    {
        std::cout << "ERROR could not bind to port 20000" << std::endl;
        exit(1);
    }else{
        ::setsockopt(r_sock, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt));
    }
        
    ::listen(r_sock,500);
}

void ClientConnector::runner()
{
    int r_newsock;
    r_newsock = ::accept(r_sock, NULL, 0);
    if (r_newsock < 0){
        std::cout << "ERROR on accept" << std::endl;
        close(r_sock);
        starter();
        return;
    }
    r_n = new Network(BIO_new_socket(r_newsock,BIO_NOCLOSE));
    r_n->start();
    r_c = new Client(r_n);
    std::async(std::launch::async,&ClientWatchdog::addClient,Server::getInstance()->getWatchdog(),r_c);
    std::async(std::launch::async,&ClientAuth::add,Server::getInstance()->getAuth(),r_c);
    r_c->start();
}

void ClientConnector::ender()
{
    
}
