all: shellcheck test build
build:
	@awk -f inline.awk src/main.sh > lib/utils.sh
clean:
	@rm lib/utils.sh
test:
	@bats tests/*.bats
shellcheck:
	@shellcheck src/*.sh
