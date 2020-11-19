ifeq ($(OS),Windows_NT)
	CC := clang
	BINEXT := .exe
	SHELL = powershell.exe
endif

PROGNAME := HelloWorld
PROGNAME := $(addsuffix $(BINEXT), $(PROGNAME))

# Recursive wildcard function
rwildcard=$(wildcard $1$2) $(foreach d, $(wildcard $1*),$(call rwildcard,$d/,$2))

# Recursively find all C source and header files in the current directory.
SRC := $(call rwildcard,,*.c)
HEADERS := $(call rwildcard,,*.h)

OBJ := $(SRC:.c=.o)
DEP := $(SRC:.c=.d)

$(PROGNAME): $(OBJ)
	$(CC) $(OBJ) -o $(PROGNAME)

-include $(DEP)

# Create dependency information for source files when creating objects.
%.o: %.c
	$(CC) -MMD -MP -c $< -o $@

run: $(PROGNAME)
	./$(PROGNAME)

ifeq ($(OS),Windows_NT)
clean:
	Get-ChildItem -Recurse -File *.o,*.d | Remove-Item -Force
Clean: clean
	-Get-ChildItem -File $(PROGNAME) -ErrorAction Ignore | Remove-Item -Force
else
clean:
	$(RM) $(OBJ) $(DEP)
Clean: clean
	$(RM) $(PROGNAME)
endif

.PHONY: clean Clean run
