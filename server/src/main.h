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
void initializeOpenSSL();


#endif /* _MAIN_H_ */
