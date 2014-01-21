#ifndef _UTILITY_H_
#define _UTILITY_H_

#include <iostream>
#include <istream>
#include <streambuf>
#include <string>
#include <algorithm>

#include <openssl/sha.h>

/* for istream creation */
class DataBuf : public std::streambuf
{
public:
    DataBuf(char *d, size_t s) {
        setg(d, d, d + s);
    }
};

class Utility {
public:
    static void sqlClean(std::string &str);
    static void sha256(const char *buf, size_t len, char *hash);
private:
    Utility();
};

#endif 