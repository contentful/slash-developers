CDA_APIARY_NAME=contentfulcda
CDA_BLUEPRINT=cda.apib
CDA_HOST=https://cdn.contentful.com

CMA_APIARY_NAME=contentfulcma
CMA_BLUEPRINT=cma.apib
CMA_HOST=https://api.contentful.com

CPA_APIARY_NAME=contentpreviewapi
CPA_BLUEPRINT=cpa.apib
CPA_HOST=https://preview.contentful.com

.PHONY: all clean fetch preview test

all: test

clean:
	rm -f $(CDA_BLUEPRINT) $(CPA_BLUEPRINT)

$(CDA_BLUEPRINT): cda-header.apib cda-body.apib
	rm -rf $@
	cat $^ >>$@

# This task replaces the CDA token with a Preview token via `sed`
$(CPA_BLUEPRINT): cpa-header.apib cda-body.apib
	rm -rf $@
	cat $^ >>$@
	sed -i '' 's/b4c0n73n7fu1/e5e8d4c5c122cf28fc1af3ff77d28bef78a3952957f15067bbc29f2f0dde0b50/g' $@

# XXX: The Apiary editor should not be used, because we use partials for CDA/CPA
#fetch:
#	apiary fetch --api-name=$(CDA_APIARY_NAME) >$(CDA_BLUEPRINT)
#	apiary fetch --api-name=$(CMA_APIARY_NAME) >$(CMA_BLUEPRINT)

preview: test
	apiary preview --path=$(CDA_BLUEPRINT)
	apiary preview --path=$(CMA_BLUEPRINT)
	apiary preview --path=$(CPA_BLUEPRINT)

publish: test
	apiary publish --api-name=$(CDA_APIARY_NAME) --path=$(CDA_BLUEPRINT)
	apiary publish --api-name=$(CMA_APIARY_NAME) --path=$(CMA_BLUEPRINT)
	apiary publish --api-name=$(CPA_APIARY_NAME) --path=$(CPA_BLUEPRINT)

test: $(CDA_BLUEPRINT) $(CPA_BLUEPRINT) $(CMA_BLUEPRINT)
	dredd $(CPA_BLUEPRINT) $(CPA_HOST)
	dredd $(CDA_BLUEPRINT) $(CDA_HOST)
	dredd $(CMA_BLUEPRINT) $(CMA_HOST) \
		-h "Authorization: Bearer $(CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN)" \
		-m GET #-m PUT -m POST #-m DELETE
