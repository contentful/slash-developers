CDA_APIARY_NAME=contentfulcda
CDA_BLUEPRINT=cda.apib
CDA_HOST=https://cdn.contentful.com

CMA_APIARY_NAME=contentfulcma
CMA_BLUEPRINT=cma.apib
CMA_HOST=https://api.contentful.com

CPA_APIARY_NAME=contentpreviewapi
CPA_BLUEPRINT=cpa.apib
CPA_HOST=https://preview.contentful.com

IMAGES_APIARY_NAME=contentfulimagesapi
IMAGES_BLUEPRINT=images.apib
IMAGES_HOST=https://images.contentful.com

DREDD=node_modules/.bin/dredd
APIARY=bundle exec apiary

.PHONY: all clean fetch preview test install

all: test

clean:
	rm -f $(CDA_BLUEPRINT) $(CPA_BLUEPRINT) $(CMA_BLUEPRINT) $(IMAGES_BLUEPRINT)

install:
	@if [ ! -f $(DREDD) ]; then \
		npm install dredd; \
	fi
	@$$(bundle show apiaryio > /dev/null); \
	if [ $$? != 0 ]; then \
		bundle install; \
	fi

$(CDA_BLUEPRINT): cda-header.apib blueprint-header.apib cda-intro.apib cda-body.apib
	rm -rf $@
	cat $^ >>$@

$(CMA_BLUEPRINT): cma-header.apib blueprint-header.apib cma-body.apib
	rm -rf $@
	cat $^ >>$@

$(IMAGES_BLUEPRINT): images-header.apib blueprint-header.apib images-body.apib
	rm -rf $@
	cat $^ >>$@

# This task replaces the CDA token with a Preview token via `sed`
$(CPA_BLUEPRINT): cpa-header.apib blueprint-header.apib cpa-intro.apib cda-body.apib
	rm -rf $@
	cat $^ >>$@
	sed 's/b4c0n73n7fu1/e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50/g' $@ >tmp
	mv tmp $@

# XXX: The Apiary editor should not be used, because we use partials for CDA/CPA
#fetch:
#	apiary fetch --api-name=$(CDA_APIARY_NAME) >$(CDA_BLUEPRINT)
#	apiary fetch --api-name=$(CMA_APIARY_NAME) >$(CMA_BLUEPRINT)

preview: test
	$(APIARY) preview --path=$(CDA_BLUEPRINT)
	$(APIARY) preview --path=$(CMA_BLUEPRINT)
	$(APIARY) preview --path=$(CPA_BLUEPRINT)
	$(APIARY) preview --path=$(IMAGES_BLUEPRINT)

publish: test
	$(APIARY) publish --api-name=$(CDA_APIARY_NAME) --path=$(CDA_BLUEPRINT)
	$(APIARY) publish --api-name=$(CMA_APIARY_NAME) --path=$(CMA_BLUEPRINT)
	$(APIARY) publish --api-name=$(CPA_APIARY_NAME) --path=$(CPA_BLUEPRINT)
	$(APIARY) publish --api-name=$(IMAGES_APIARY_NAME) --path=$(IMAGES_BLUEPRINT)

test: $(CDA_BLUEPRINT) $(CPA_BLUEPRINT) $(CMA_BLUEPRINT) $(IMAGES_BLUEPRINT)
	$(DREDD) $(CPA_BLUEPRINT) $(CPA_HOST)
	$(DREDD) $(CDA_BLUEPRINT) $(CDA_HOST)
	$(DREDD) $(CMA_BLUEPRINT) $(CMA_HOST) \
		-h "Authorization: Bearer $(CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN)" \
		-m GET #-m PUT -m POST #-m DELETE
	#$(DREDD) $(IMAGES_BLUEPRINT) $(IMAGES_HOST)
