# -----------------------------------------
# Sonnet Portable Makefile
# Detects OS and builds
# -----------------------------------------

# Default target
all: detect

# -----------------------------------------
# OS Detection
# -----------------------------------------

detect:
	@echo "Detecting OS..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		$(MAKE) windows; \
	else \
		unameOut=$$(uname -s); \
		case $$unameOut in \
			Linux*)   $(MAKE) linux ;; \
			Darwin*)  $(MAKE) macos ;; \
			*)        echo "Unsupported OS: $$unameOut"; exit 1 ;; \
		esac \
	fi

# -----------------------------------------
# Linux Build
# -----------------------------------------

linux:
	@echo "Building Sonnet for Linux..."
	mkdir -p build
	g++ src/main.cpp -o build/sonnetc \
		-O3 `llvm-config --cxxflags --ldflags --libs core` \
		-ldl -lpthread
	@echo "Linux build complete → build/sonnetc"

# -----------------------------------------
# macOS Build
# -----------------------------------------

macos:
	@echo "Building Sonnet for macOS..."
	mkdir -p build
	clang++ src/main.cpp -o build/sonnetc \
		-O3 \
		-I /opt/homebrew/opt/llvm/include \
		-L /opt/homebrew/opt/llvm/lib \
		-lLLVM
	@echo "macOS build complete → build/sonnetc"

# -----------------------------------------
# Windows Build (MSVC)
# -----------------------------------------

windows:
	@echo "Building Sonnet for Windows (MSVC)..."
	if not exist build mkdir build
	cl /EHsc /O2 src\main.cpp /Fe:build\sonnetc.exe ^
		/I "C:\Program Files\LLVM\include" ^
		/link /LIBPATH:"C:\Program Files\LLVM\lib" LLVM.lib
	@echo "Windows build complete → build\sonnetc.exe"

# -----------------------------------------
# Clean
# -----------------------------------------

clean:
	rm -rf build
	@echo "Cleaned."
