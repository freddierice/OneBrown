#include "main.h"

int main(int argc, const char **argv)
{
    /*
    Server::getInstance()->getConnector()->start();
    std::this_thread::sleep_for(std::chrono::minutes(10));
    */
    
    for(int i = 0; i < 100; ++i){
        Database *d = new Database();
        delete d;
    }
    return 0;
}