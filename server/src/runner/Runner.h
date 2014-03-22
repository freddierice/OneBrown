#ifndef _RUNNER_H_
#define _RUNNER_H_

#include <thread>
#include <atomic>
#include <chrono>

class Runner {
public:
    void start();
    void stop(bool blocking);
    bool isRunning();
    
protected:
    virtual void starter();
    virtual void runner() = 0;
    virtual void ender();
    Runner();
    ~Runner();
    
private:
    void runStart();
    std::atomic<bool> m_isRunning;
    std::thread m_thread;
};

#endif /*_RUNNER_H_*/