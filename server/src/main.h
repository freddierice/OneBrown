
#ifndef _MAIN_H_
#define _MAIN_H_

#include <iostream>
#include <thread>
#include <chrono>
#include <vector>

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>

#include "client/Client.h"
#include "network/Network.h"

#define PORT 20001

std::vector<Client *> clients;

void connect();

#endif /* _MAIN_H_ */
