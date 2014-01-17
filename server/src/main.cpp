#include "main.h"

int main()
{
    connect();
    
    return 0;
}

void connect()
{
    int sockfd, newsockfd;
    unsigned int clilen;
    char buffer[256];
    struct sockaddr_in serv_addr, cli_addr;
    int  n;
    
    /* First call to socket() function */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
    {
        std::cout << "ERROR opening socket" << std::endl;
        exit(1);
    }
    /* Initialize socket structure */
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(PORT);
    
    if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
    {
        std::cout << "ERROR could not bind to port 20000" << std::endl;
        exit(1);
    }
    
    listen(sockfd,500);
    clilen = sizeof(cli_addr);
    Client *c;
    while(true) 
    {
        newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
        if (newsockfd < 0)
        {
            std::cout << "ERROR on accept" << std::endl;
            exit(1);
        }
        c = new Client(newsockfd);
        c->start();
        clients.push_back(c);
    } 
}