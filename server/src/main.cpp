#include "main.h"

int main()
{
    initializeOpenSSL();
    initializeSocket();
    connect();
    
    return 0;
}

void connect()
{
    ClientCollector *cc;
    int newsock;
    
    cc = new ClientCollector();
    cc->start();
    listen(sock,500);
    while(true) 
    {
        newsock = accept(sock, NULL, 0);
        if (newsock < 0){
            std::cout << "ERROR on accept" << std::endl;
            close(sock);
            initializeSocket();
            continue;
        }
        std::async(std::launch::async,&ClientCollector::addClient,cc,BIO_new_socket(newsock,BIO_NOCLOSE));
    } 
}

void initializeSocket()
{
    struct sockaddr_in serv_addr;
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(PORT);
    
    if (bind(sock, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
    {
        std::cout << "ERROR could not bind to port 20000" << std::endl;
        exit(1);
    }
}

void initializeOpenSSL()
{
    CRYPTO_malloc_init();
    SSL_library_init();
    SSL_load_error_strings();
    ERR_load_BIO_strings();
    OpenSSL_add_all_algorithms();
}
