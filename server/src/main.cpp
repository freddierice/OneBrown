#include "main.h"

int main()
{
    connect();
    
    return 0;
}

void connect()
{
    SSL_CTX *ctx;
    char *portnum;
    ClientCollector *cc;
    int newsock;
    
    ctx = initializeOpenSSL();
    initializeCerts(ctx, "certf.pem", "keyf.pem");
    initializeSocket();
    
    cc = new ClientCollector();
    cc->start();
    listen(sock,500);
    while(true) 
    {
        SSL *ssl;
        newsock = accept(sock, NULL, 0);
        if (newsock < 0){
            std::cout << "ERROR on accept" << std::endl;
            close(sock);
            initializeSocket();
            continue;
        }
        ssl = SSL_new(ctx);
        SSL_set_fd(ssl,newsock);
        std::async(std::launch::async,&ClientCollector::addClient,cc,BIO_new_socket(newsock,BIO_NOCLOSE));
    }
    close(sock);
    SSL_CTX_free(ctx);
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

SSL_CTX* initializeOpenSSL()
{
    SSL_METHOD *method;
    SSL_CTX *ctx;
    
    CRYPTO_malloc_init();
    SSL_library_init();
    SSL_load_error_strings();
    ERR_load_BIO_strings();
    OpenSSL_add_all_algorithms();
    
    method = (SSL_METHOD *)SSLv2_server_method();
    ctx = SSL_CTX_new(method);
    if( ctx == NULL){
        ERR_print_errors_fp(stderr);
        exit(1);
    }else{
        return ctx;
    }
}

void initializeCerts(SSL_CTX* ctx, std::string certf, std::string keyf)
{
    if ( SSL_CTX_use_certificate_file(ctx, certf.c_str(), SSL_FILETYPE_PEM) <= 0 )
    {
        ERR_print_errors_fp(stderr);
        exit(1);
    }
    
    if ( SSL_CTX_use_PrivateKey_file(ctx, keyf.c_str(), SSL_FILETYPE_PEM) <= 0 )
    {
        ERR_print_errors_fp(stderr);
        exit(1);
    }
    
    if ( !SSL_CTX_check_private_key(ctx) )
    {
        std::cout << "Private key does not match the public certificate" << std::endl;
        exit(1);
    }
}
