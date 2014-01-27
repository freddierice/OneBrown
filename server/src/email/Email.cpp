#include "Email.h"

Email::Email()
{
    m_m1 = "Thank you for signing up for signing up for OneBrown! Please verify that this is your email address by entering this verification code into the OneBrown application on your mobile device. \n\n Code: ";
    m_m2 = "\n\nPlease do not respond to this email.\r\n";
    m_to1 = "RCPT TO:<";
    m_to2 = "@brown.edu>\n";
    m_to3 = "@brown.edu>\r\n";
    m_brownHostname = "alt1.aspmx.l.google.com";
    m_amazonHostname = "email-smtp.us-east-1.amazonaws.com:465";
    m_port = "25";
    m_buf = new char[BUF_LEN];
}

Email::~Email()
{
    ::close(m_sock);
    delete m_buf;
}

bool Email::sendCode(std::string user, std::string code)
{
    std::string to,msg,tmp;
    
    to = m_to1 + user + m_to2;
    msg = m_m1 + code + m_m2;
    
    setup(m_brownHostname);
    recv();
    send("HELO\n");
    recv();
    tmp = "MAIL FROM:<person@person.com>\n";
    send(tmp.c_str());
    recv();
    send(to);
    recv();
    if(m_buf[0] != '2')
        return false;

    CRYPTO_malloc_init(); 
    SSL_library_init(); 
    SSL_load_error_strings(); 
    ERR_load_BIO_strings(); 
    OpenSSL_add_all_algorithms(); 
    
    SSL_CTX* ctx = SSL_CTX_new(SSLv23_client_method());
    SSL* ssl;
    
    BIO* bio = BIO_new_ssl_connect(ctx);
    BIO_get_ssl(bio, &ssl);
    SSL_set_mode(ssl, SSL_MODE_AUTO_RETRY);
    
    BIO_set_conn_hostname(bio, m_amazonHostname.c_str());
    BIO_do_connect(bio);
    BIO_do_handshake(bio);

    m_len = BIO_read(bio, m_buf, BUF_LEN) - 1;
    BIO_puts(bio, "HELO localhost\r\n");
    m_len = BIO_read(bio, m_buf, BUF_LEN) - 1;
    BIO_puts(bio,"AUTH LOGIN\r\n");
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"QUtJQUlFVzJDMlU3RUZYTU5PUVE=\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"QWd3TkZSOUJyb2dUTUkxYlJHeXh4dHZMYm4reldGZCtYSFJMbnJpNzZ5RC8=\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"MAIL FROM:OneBrownNetwork@gmail.com\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    to = m_to1 + user + m_to3;
    BIO_puts(bio,to.c_str()); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"DATA\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"Subject:OneBrown Verification\r\n\r\n"); 
    BIO_puts(bio,msg.c_str()); 
    BIO_puts(bio,"\r\n.\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    BIO_puts(bio,"QUIT\r\n"); 
    m_len = BIO_read(bio,m_buf,BUF_LEN) - 1;
    
    BIO_free_all(bio);
    
    SSL_CTX_free(ctx);
}

void Email::send(std::string s)
{
    ::send(m_sock,s.c_str(),s.length(),0);
}

void Email::recv()
{
    m_len = ::recv(m_sock,m_buf,BUF_LEN,0);
}

void Email::print()
{
    for(int i = 0; i < m_len; ++i)
        std::cout << m_buf[i];
    std::cout << std::endl;
}

void Email::setup(std::string h)
{
    ::close(m_sock); 
    m_sock = ::socket(AF_INET, SOCK_STREAM, 0);
    
    ::getaddrinfo(h.c_str(),m_port.c_str(),NULL,&m_result);
    ::connect(m_sock, m_result->ai_addr, m_result->ai_addrlen);
}