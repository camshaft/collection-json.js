
# Detect if we're running Windows
ifdef SystemRoot
    # If so, set the file & folder deletion commands:
    FixPath = $(subst /,\,$1)
    ENVVAR = @SET NODE_ENV=test & 
else
    # Otherwise, assume we're running *N*X:
    FixPath = $1
    ENVVAR = @NODE_ENV=test
endif

NODE_MODULES = node_modules/.bin/
BROWSERIFY = node_modules/browserify/bin/
BUILD = build/
BROWSER = browser/
TEST_ROOT = test/
ACCEPTANCE = test/acceptance/
DOCS = docs/*.md
HTMLDOCS = $(DOCS:.md=.html)
REPORTER = spec

test:
	@echo "Testing"
	$(ENVVAR) $(call FixPath, $(NODE_MODULES))mocha --reporter $(REPORTER) --compilers coffee:coffee-script \
        $(call FixPath, $(TEST_ROOT))test.coffee

test-acceptance: 
	@echo "Testing Acceptance"
	$(ENVVAR) $(call FixPath, $(NODE_MODULES))mocha --compilers coffee:coffee-script --reporter $(REPORTER) \
		$(call FixPath, $(ACCEPTANCE))integration.coffee

build:
	@mkdir -p build

build/collection-json.js: build
	@echo "Building bare"
	$(call FixPath, $(BROWSERIFY))cmd.js \
		-i 'underscore' \
		$(call FixPath, $(BROWSER))cj.bare.coffee \
		-o $(call FixPath, $(BUILD))collection-json.js
        
build/collection-json.min.js: build
	@echo "Minify bare"
	$(call FixPath, $(NODE_MODULES))uglifyjs \
		-o $(call FixPath, $(BUILD))collection-json.min.js \
		$(call FixPath, $(BUILD))collection-json.js

build/collection-json.angular.js: build
	@echo "Building angular"
	$(call FixPath, $(BROWSERIFY))cmd.js \
		-i 'underscore' \
		$(call FixPath, $(BROWSER))cj.angular.coffee \
		-o $(call FixPath, $(BUILD))collection-json.angular.js
build/collection-json.angular.min.js: build
	@echo "Minify angular"
	$(call FixPath, $(NODE_MODULES))uglifyjs \
		-o $(call FixPath, $(BUILD))collection-json.angular.min.js \
		$(call FixPath, $(BUILD))collection-json.angular.js

build/jquery.collection-json.js: build
	@echo "Building jquery"
	$(call FixPath, $(BROWSERIFY))cmd.js \
		-i 'underscore' \
		$(call FixPath, $(BROWSER))cj.jquery.coffee \
		-o $(call FixPath, $(BUILD))jquery.collection-json.js
        
build/jquery.collection-json.min.js: build
	@echo "Minify jquery"
	$(call FixPath, $(NODE_MODULES))uglifyjs \
		-o $(call FixPath, $(BUILD))jquery.collection-json.min.js \
		$(call FixPath, $(BUILD))jquery.collection-json.js

client: build build/collection-json.js build/collection-json.min.js \
				build/collection-json.angular.js build/collection-json.angular.min.js\
				build/jquery.collection-json.js build/jquery.collection-json.min.js

.PHONY: test test-acceptance client
