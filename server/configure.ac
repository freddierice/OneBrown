AC_INIT([OneBrown Server], [1.0], [OneBrownNetwork@gmail.com],
             [onebrown], [http://www.OneBrownNetwork.com/])
AC_PREREQ([2.59])
AM_INIT_AUTOMAKE([1.10 -Wall no-define])
#CXXFLAGS="$CXXFLAGS -g"
AC_PROG_CXX
CXXFLAGS="$CXXFLAGS -std=c++11"

#Mysql Library
AC_CHECK_LIB([mysqlcppconn], [main], [], [a=0])
if test "$a" == "0"
then
    AC_MSG_ERROR([MySQL library is missing. Look at the README to install.])
fi

#Json Library
AC_CHECK_LIB([json], [main], [], [a=0])
if test "$a" == "0"
then
    AC_MSG_ERROR([CppJson library is missing. Look at the README to install.])
fi

#OpenSSL Library SSL
AC_CHECK_LIB([ssl], [main], [], [a=0])
if test "$a" == "0"
then
    AC_MSG_ERROR([OpenSSL SSL library is missing. Your native ssh client should depend on this...])
fi

#OpenSSL Library Crypto
AC_CHECK_LIB([crypto], [main], [], [a=0])
if test "$a" == "0"
then
    AC_MSG_ERROR([OpenSSL crypto library is missing. Your native ssh client should depend on this...])
fi

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
