#CONFIGURATION
JFLAGS = -g
JC = javac
BUILD_DIR=build
SRC_DIR=src

#AUTOMATION
JFLAGS:=$(JFLAGS) -cp $(BUILD_DIR) -d $(BUILD_DIR)
SOURCES = $(wildcard $(SRC_DIR)/*.java)
CLASSES = $(SOURCES:.java=.class)

all: $(SOURCES) $(CLASSES)

%.class: %.java
	$(JC) $(JFLAGS) $<

clean:
	$(RM) $(BUILD_DIR)/*.class
