#CONFIGURATION
JFLAGS = -g
JC = javac
BUILD_DIR=build
SRC_DIR=src

#AUTOMATION
JFLAGS:=$(JFLAGS) -cp $(BUILD_DIR) -d $(BUILD_DIR)
SOURCES = $(wildcard $(SRC_DIR)/*.java)
CLASSES = $(SOURCES:.java=.class)

all: check_dirs $(SOURCES) $(CLASSES)

%.class: %.java
	$(JC) $(JFLAGS) $<

check_dirs: $(BUILD_DIR)

$(BUILD_DIR): 
	mkdir $(BUILD_DIR)

clean:
	$(RM) $(BUILD_DIR)/*.class
