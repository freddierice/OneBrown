#ifndef _MAIN_H_
#define _MAIN_H_

#include <iostream>
#include <thread>
#include <future>
#include <chrono>
#include <vector>

#include <stdlib.h>
#include <stdio.h>

#include <openssl/bio.h>
#include <openssl/ssl.h>

#include "client/Client.h"
#include "network/Network.h"

#define PORT 20000

int sock;

void connect();
void initializeSocket();
SSL_CTX* initializeOpenSSL();
void initializeCerts(SSL_CTX* ctx, std::string certf, std::string keyf);


#endif /* _MAIN_H_ */
