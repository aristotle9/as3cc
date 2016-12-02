import org.lala.lex.utils.parser.RegexLexer;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by lanfan on 16/11/25.
 */
public class Lexer {

    public static void main(String[] args) {

        try {
            List<RegexLexer.TokenItem> list = RegexLexer.LexSeq("\\x5\\u5730(a|b)*abb");
            System.out.println(list);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
