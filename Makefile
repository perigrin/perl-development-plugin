# ABOUTME: Build targets for the perl-development plugin.
# ABOUTME: Includes chain validation and plugin structure verification.

.PHONY: validate-chain test-validate-chain

validate-chain:
	@./scripts/validate-chain.sh

test-validate-chain: validate-chain
	@echo ""
	@echo "=== Testing validation catches broken conditions ==="
	@./scripts/test-validate-chain.sh
