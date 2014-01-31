#include "Cache.h"

Cache::Cache()
{
    
}

void Cache::setValue(std::string key, std::string value)
{
    m_cache[key] = value;
}

std::string Cache::getValue(std::string key)
{
    return m_cache[key];
}