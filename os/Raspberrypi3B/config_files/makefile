# makefile for setup_nat

setup_nat:
	nft -f setup_nat.nft
	sysctl net.ipv4.ip_forward=1
.PHONY: setup_nat

# end sceext 20171231

