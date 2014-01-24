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

void Utility::bytesToBase64(const char *buf, size_t len, std::string &str)
{
    BIO *bmem, *b64;
    BUF_MEM *bptr;
    char *outBuf;
    
    b64 = BIO_new(BIO_f_base64());
    bmem = BIO_new(BIO_s_mem());
    b64 = BIO_push(b64,bmem);
    BIO_set_flags(b64,BIO_FLAGS_BASE64_NO_NL);
    BIO_write(b64, buf, len);
    BIO_flush(b64);
    BIO_get_mem_ptr(b64, &bptr);
    
    outBuf = bptr->data;
    len = bptr->length;
    for(int i = 0; i < bptr->length; ++i)
        str.push_back(outBuf[i]);
    
    BIO_free_all(b64);
}

void Utility::base64ToBytes(char *buf, size_t len, std::string &str)
{
    BIO *b64, *bmem;
    
    b64 = BIO_new(BIO_f_base64());
    bmem = BIO_new_mem_buf((char *)str.c_str(), str.length());
    bmem = BIO_push(b64, bmem);
    BIO_set_flags(bmem,BIO_FLAGS_BASE64_NO_NL);
    BIO_read(bmem, buf, len);
    
    BIO_free_all(bmem);
}