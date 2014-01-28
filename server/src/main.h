
#ifndef _MAIN_H_
#define _MAIN_H_

#include <iostream>
#include <thread>
#include <chrono>
#include <vector>

#include <stdlib.h>
#include <stdio.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <netdb.h>

#include <openssl/bio.h>
#include <openssl/ssl.h>

#include "client/Client.h"
#include "network/Network.h"

#define PORT 20000

std::vector<Client *> clients;
int sock;

void connect();
void initializeSocket();
void initializeOpenSSL();


#endif /* _MAIN_H_ */
