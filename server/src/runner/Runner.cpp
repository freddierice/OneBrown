#include "Runner.h"

Runner::Runner(){}
Runner::~Runner(){}

void Runner::start()
{
    if(!m_isRunning){
        m_isRunning = true;
        m_thread = std::thread(&Runner::runStart,this);
    }
}

void Runner::runStart()
{
    starter();
    while(m_isRunning)
        runner();
    ender();
    m_thread.detach();
}

void Runner::stop(bool blocking)
{
    if(!isRunning())
        return;
    else{
        m_isRunning = false;
        if(blocking)
            while(isRunning())
                std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
}

bool Runner::isRunning()
{
    return m_thread.joinable();
}

void Runner::starter(){}
void Runner::ender(){}