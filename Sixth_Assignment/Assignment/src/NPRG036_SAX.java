
import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;
import org.xml.sax.helpers.DefaultHandler;


/**
 * Main class for SAX parsing
 * @author XML Technologies
 */
public class NPRG036_SAX {

    // Path to input file
    private static final String INPUT_FILE = "data.xml";

    /**
     * Main method
     * @param args command line arguments
     */
    public static void main(String[] args) {

        try {

            // Create parser instance
            XMLReader parser = XMLReaderFactory.createXMLReader();

            // Create input stream from source XML document
            InputSource source = new InputSource(INPUT_FILE);

            // Set our custom content handler for handling SAX events
            parser.setContentHandler(new CustomContentHandler());

            // Process input data
            parser.parse(source);

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}
