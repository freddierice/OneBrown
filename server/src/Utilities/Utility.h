#ifndef _UTILITY_H_
#define _UTILITY_H_

#include <iostream>
#include <istream>
#include <streambuf>
#include <string>
#include <algorithm>

#include <cmath>

#include <openssl/sha.h>
#include <openssl/bio.h>
#include <openssl/evp.h>
#include <openssl/buffer.h>


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
    static void bytesToBase64(const char *buf, size_t len, std::string &str);
    static void base64ToBytes(char *buf, size_t len, std::string &str);
private:
    Utility();
};

#endif 