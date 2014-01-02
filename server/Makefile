#CONFIGURATION
JFLAGS = -g
JC = javac
BUILD_DIR=build
SRC_DIR=src
PACKAGE=pack

#AUTOMATION
JFLAGS:=$(JFLAGS) -cp $(BUILD_DIR):$(BUILD_DIR)/$(PACKAGE):$(CLASSPATH) -d $(BUILD_DIR)
SOURCES = $(wildcard $(SRC_DIR)/*.java)
CLASSES = $(patsubst $(SRC_DIR)/%.java,$(BUILD_DIR)/$(PACKAGE)/%.class,$(SOURCES))

all: check_dirs $(SOURCES) $(CLASSES)

$(BUILD_DIR)/$(PACKAGE)/%.class: $(SRC_DIR)/%.java
	$(JC) $(JFLAGS) $<

check_dirs: $(BUILD_DIR)

$(BUILD_DIR): 
	mkdir $(BUILD_DIR)

clean:
	$(RM) $(BUILD_DIR)/$(PACKAGE)/*.class
