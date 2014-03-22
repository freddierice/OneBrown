#include "main.h"

int main(int argc, const char **argv)
{
    
    Server *s = Server::getInstance();
    s->getConnector()->start();
    std::this_thread::sleep_for(std::chrono::minutes(10));
    
    return 0;
}