#include "main.h"

int main(int argc, const char **argv)
{
    Server::getInstance()->getConnector()->start();
    std::this_thread::sleep_for(std::chrono::minutes(10));
    
    return 0;
}