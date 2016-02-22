.PHONY: all clean build

build:
	swift build

test: build
	./.build/debug/cathode Examples/1

clean:
	swift build --clean
