#ifndef EMAIL_H
#define EMAIL_H

#include <iostream>
#include <string>

/* Extra C Headers */
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>

/* OpenSSL Library */
#include <openssl/bio.h>
#include <openssl/ssl.h>
#include <openssl/sha.h>
#include <openssl/evp.h>
#include <openssl/buffer.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#define BUF_LEN 1024

class Email {
public:
    Email();
    ~Email();
    
    bool sendCode(std::string user, std::string code);
    bool testUser(std::string user);
    void send(std::string s);
    void recv();
    
private:
    void setup(std::string h);
    void print();
    
    std::string m_m1, m_m2,m_to1,m_to2,m_to3;
    std::string m_brownHostname, m_amazonHostname, m_port;
    int m_sock,m_len;
    struct addrinfo *m_result;
    char *m_buf;
};

#endif /* EMAIL_H */