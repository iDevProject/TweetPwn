FILE=TweetPwn.xm
NAME=TweetPwn.dylib
CC=g++
FLAGS=-lobjc -dynamiclib -framework Foundation -framework ScriptingBridge -framework AppKit -o $(NAME)
all:
	@echo "Parsing code..."
	@./LogosToStar.sh $(FILE) >fix.m
	@echo "Compiling and linking..."
	@$(CC) $(FLAGS) fix.m
	@echo "Cleaning up..."
	@rm -rf fix.m star.h
