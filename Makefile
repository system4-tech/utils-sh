build:
	@awk 'FNR==1 && NR!=1 && /^#!/ { next } { print }' src/*.sh > lib/utils.sh
test:
	@bats tests/*.bats
shellcheck:
	@shellcheck src/*.sh
