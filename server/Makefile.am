AUTOMAKE_OPTIONS = subdir-objects
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS}

bin_PROGRAMS = out
out_SOURCES = src/network/Network.cpp src/network/Network.h src/database/Database.h src/database/Database.cpp src/utility/Utility.h src/utility/Utility.cpp src/network/Email.h src/network/Email.cpp src/client/Client.h src/client/Client.cpp src/runner/Runner.h src/runner/Runner.cpp src/client/ClientWatchdog.h src/client/ClientWatchdog.cpp src/client/ClientConnector.h src/client/ClientConnector.cpp src/client/ClientAuth.h src/client/ClientAuth.cpp  src/client/ClientRunner.h src/client/ClientRunner.cpp src/client/ClientResponder.h src/client/ClientResponder.cpp src/client/Server.h src/client/Server.cpp src/main.h src/main.cpp

BUILT_SOURCES = src/common.h.gch 
src/common.h.gch: src/common.h 
        $(CXX) -c common.h -std=c++11 -O2
