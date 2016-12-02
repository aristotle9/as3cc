import org.lala.lex.utils.parser.RegexLexer;
import org.lala.lex.utils.parser.RegexParser;

/**
 * Created by lanfan on 16/11/25.
 */
public class Parser {
    public static void main(String[] args) {
        try {
            if (args.length > 0) {
                String reg = args[0];
                Object res = RegexParser.parse(reg);
                System.out.println("Parsed!");
                System.out.println(res);
            } else {
                System.out.println("no argument");
            }
        } catch (Exception e) {
            System.out.println("Error!");
            e.printStackTrace();
        }
    }
}
