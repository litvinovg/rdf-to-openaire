package org.vivoweb.rdf2openaire;

import static org.hamcrest.MatcherAssert.assertThat;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.file.Files;
import java.util.stream.Stream;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Named;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.xml.sax.SAXException;
import org.xmlunit.builder.Input;
import org.xmlunit.matchers.CompareMatcher;
import org.apache.commons.io.FileUtils;

class ConversionTest {

	private static final String OPENAIRE_TEST = "openaire_test_xml";
	private static final String RDF_TEST = "rdf_test_xml";
	private static File rdf = new File("src/test/resources/rdf_test_xml");
	private static File xsd = new File("src/test/resources/openaire-cerif-profile.xsd");
	private static File xslt = new File("src/main/resources/rdf_to_openaire.xsl");
	private static Transformer transformer;
	private static boolean UPDATE = true;

	@BeforeAll
	public static void init() throws TransformerConfigurationException {
		StreamSource xsltSource = new StreamSource(xslt);
		TransformerFactory transformerFactory = new net.sf.saxon.TransformerFactoryImpl();
		transformer = transformerFactory.newTransformer(xsltSource);
	}

	@ParameterizedTest
	@MethodSource("requests")
	public void person(File input) throws Exception {
		File control = new File(input.toString().replace(RDF_TEST, OPENAIRE_TEST));
		test(input, control);
	}

	private void test(File input, File control) throws Exception {
		StreamSource inputSource = new StreamSource(input);
		Source controlSource = new StreamSource(control);
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		transformer.transform(inputSource, new StreamResult(output));
		Source test = Input.fromByteArray(output.toByteArray()).build();
		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		try {
			Schema schema = schemaFactory.newSchema(xsd);
			Validator validator = schema.newValidator();
			validator.validate(test);
		} catch (SAXException e) {
			System.out.println(control.getPath() + " is NOT valid:" + e);
			throw e;
		}
		if (UPDATE) {
			control.getParentFile().mkdirs();
			Files.write(control.toPath(), output.toByteArray());
		} else {
			assertThat(test, CompareMatcher.isIdenticalTo(controlSource));
		}
	}

	public static Stream<Arguments> requests() {
		return FileUtils.listFiles(rdf, new String[] { ".xml" }, true).stream()
				.map(file -> Arguments.of(Named.of(file.getPath(), file)));
	}
}
