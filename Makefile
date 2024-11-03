build:
	@awk -f inline.awk src/main.sh > lib/utils.sh
test:
	@bats tests/*.bats
shellcheck:
	@shellcheck src/*.sh
