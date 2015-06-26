---
page: :docsLocales
---

A Space in Contentful can have multiple locales, defined by ISO locale codes like `en-US` or `de-DE`. Each field is localized individually and you can also provide localized variants of an Asset's file.

The CDA provides content in the default locale by default, but can request a different one using the `locale` query parameter. If there is no localized value for the specified locale, you will receive the corresponding value from the default locale:

	{
	  "sys": {
	    "locale": "tlh"
	    ...
	  },
	  "fields": {
	    "name": "Nyan vIghro'"
	    ...
	  }
	}

Using the Sync API, you will receive all localized content at once:

	{
	  "fields": {
	    "title": {
	      "en-US": "Nyan cat has been spotted in the wild!",
	      "tlh": "chaDo'maq nyan vIghro' qaStaHvIS qu'bogh!"
	    }
	  }
	}

When using the CMA, you will always receive all localized content at once and will have to specify all localized values at the same time:

	{
	  "fields": {
	    "title": {
	      "en-US": "Hello, World!",
	      "de-DE": "Hallo, Welt!"
	    },
	    "body": {
	      "en-US": "Bacon is healthy!",
	      "de-DE": "Bacon ist gesund!"
	    }
	  }
	}
