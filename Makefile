
# Detect if we're running Windows
ifdef SystemRoot
    # If so, set the file & folder deletion commands:
    FixPath = $(subst /,\,$1)
else
    # Otherwise, assume we're running *N*X:
    FixPath = $1
endif

NODE_MODULES := ./node_modules/.bin/
BROWSERIFY := ./node_modules/browserify/bin/
DOCS = docs/*.md
HTMLDOCS = $(DOCS:.md=.html)
REPORTER = spec

test:
	@NODE_ENV=test $(call FixPath, NODE_MODULES)mocha \
		--reporter $(REPORTER) --compilers coffee:coffee-script test/test.coffee

test-acceptance:
	@NODE_ENV=test $(call FixPath, NODE_MODULES)mocha \
		--compilers coffee:coffee-script --reporter $(REPORTER) \
		test/acceptance/integration.coffee

build:
	@mkdir -p build

build/collection-json.js: build
	@echo "Building bare"
	$(call FixPath, BROWSERIFY)cmd.js \
		-i 'underscore' \
		browser/cj.bare.coffee \
		-o build/collection-json.js
build/collection-json.min.js: build
	@echo "Minify bare"
	$(call FixPath, NODE_MODULES)uglifyjs \
		-o ./build/collection-json.min.js \
		./build/collection-json.js

build/collection-json.angular.js: build
	@echo "Building angular"
	$(call FixPath, BROWSERIFY)cmd.js \
		-i 'underscore' \
		browser/cj.angular.coffee \
		-o build/collection-json.angular.js
build/collection-json.angular.min.js: build
	@echo "Minify angular"
	$(call FixPath, NODE_MODULES)uglifyjs \
		-o ./build/collection-json.angular.min.js \
		./build/collection-json.angular.js

build/jquery.collection-json.js: build
	@echo "Building jquery"
	$(call FixPath, BROWSERIFY)cmd.js \
		-i 'underscore' \
		browser/cj.jquery.coffee \
		-o build/jquery.collection-json.js
build/jquery.collection-json.min.js: build
	@echo "Minify jquery"
	$(call FixPath, NODE_MODULES)uglifyjs \
		-o ./build/jquery.collection-json.min.js \
		./build/jquery.collection-json.js

client: build build/collection-json.js build/collection-json.min.js \
				build/collection-json.angular.js build/collection-json.angular.min.js\
				build/jquery.collection-json.js build/jquery.collection-json.min.js

.PHONY: test test-acceptance client
