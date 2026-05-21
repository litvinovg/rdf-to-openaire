# Mapping implementation of RDF/XML data into OpenAIRE 1.2.0 format 

This repository contains XSLT rules for conversion metadata from VIVO RDF/XML into OpenAIRE 1.2.0 XML in accordance with [OpenAIRE guidelines for CRIS managers.](https://github.com/openaire/guidelines-cris-managers)

- [Conversion XSLT rules ](/src/main/resources/rdf_to_openaire.xsl)
- [Examples of input data in RDF/XML](/src/test/resources/rdf)
- [OpenAIRE conversion result examples](/src/test/resources/openaire)

# Validation
To test validation of the conversion rules run
```mvn install```
It will run conversion for all RDF/XML examples and validate the results against OpenAIRE 1.2.0 Schema.
