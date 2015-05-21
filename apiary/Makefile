CDA_APIARY_NAME=contentfulcda
CDA_BLUEPRINT=cda.apib
CDA_HOST=https://cdn.contentful.com

CMA_APIARY_NAME=contentfulcma
CMA_BLUEPRINT=cma.apib
CMA_HOST=https://api.contentful.com

.PHONY: all fetch preview test

all: test

fetch:
	apiary fetch --api-name=$(CDA_APIARY_NAME) >$(CDA_BLUEPRINT)
	apiary fetch --api-name=$(CMA_APIARY_NAME) >$(CMA_BLUEPRINT)

preview: test
	apiary preview --path=$(CDA_BLUEPRINT)
	apiary preview --path=$(CMA_BLUEPRINT)

publish: test
	apiary publish --api-name=$(CDA_APIARY_NAME) --path=$(CDA_BLUEPRINT)
	apiary publish --api-name=$(CMA_APIARY_NAME) --path=$(CMA_BLUEPRINT)

test:
	dredd $(CDA_BLUEPRINT) $(CDA_HOST)
	dredd $(CMA_BLUEPRINT) $(CMA_HOST) \
		-h "Authorization: Bearer $(CONTENTFUL_MANAGEMENT_API_ACCESS_TOKEN)" \
		-m GET #-m PUT -m POST #-m DELETE
