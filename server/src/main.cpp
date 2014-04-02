#include "main.h"

int main(int argc, const char **argv)
{
    
    Server *s = Server::getInstance();
    s->getConnector()->start();
    s->getWatchdog()->start();
    std::this_thread::sleep_for(std::chrono::hours(365*24));
    
    return 0;
}