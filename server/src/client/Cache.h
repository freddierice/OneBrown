#ifndef _CACHE_H_
#define _CACHE_H_

#include <iostream>
#include <string>
#include <unordered_map>

class Cache {
public:
    Cache();
    
    void setValue(std::string key, std::string value);
    std::string getValue(std::string key);
private:
    std::unordered_map<std::string,std::string> m_cache;
};


#endif /* _CACHE_H_ */