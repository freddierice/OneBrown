#include "Utility.h"

Utility::Utility(){}

void Utility::sqlClean(std::string &str){
    std::string::reverse_iterator rit;
    for(rit = str.rbegin(); rit != str.rend(); ++rit)
        if(!isalnum(*rit) && *rit != '_')
            str.erase((rit+1).base());
}

void Utility::sha256(const char *buf, size_t len, char *hash)
{
    SHA256_CTX ctx;
    SHA256_Init(&ctx);
    SHA256_Update(&ctx, buf, len);
    SHA256_Final((unsigned char *)hash, &ctx);
}