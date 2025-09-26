# Makefile for JMIX spec validation

.PHONY: install validate validate-manifest validate-metadata validate-files validate-audit

install:
	npm install

validate: validate-manifest validate-metadata validate-files validate-audit

validate-manifest:
	npm run validate:manifest

validate-metadata:
	npm run validate:metadata

validate-files:
	npm run validate:files

validate-audit:
	npm run validate:audit
