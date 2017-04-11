import org.lala.lex.utils.parser.RegexParser;

import java.io.*;
import java.util.Iterator;
import java.util.LinkedList;

/**
 * Created by lanfan on 11/04/2017.
 */
public class RegexAnalysis {
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("input file required!");
            return;
        }
        File file = new File(args[0]);
        if (!file.exists()) {
            System.out.println("input file not exist!");
            return;
        }
        FileInputStream in = new FileInputStream(file);
        InputStreamReader inr = new InputStreamReader(in);
        BufferedReader reader = new BufferedReader(inr);
        String line;
        int total = 0;
        int err_counts = 0;
        LinkedList<int[]> out = new LinkedList<int[]>();
        while ((line = reader.readLine()) != null) {
            total += 1;
            try {
                long start = System.nanoTime();
                /// 修改后 parse 不返回 codes 了，要统计需要切回旧版: a3ecbd47197452ec9cbbbf66739f52ca9c8a2cd6
                LinkedList<Object> code = (LinkedList<Object>)RegexParser.parse(line);
                long cost = System.nanoTime() - start;
                int ask_c = count("ask", code);
                int cat_c = count("cat", code);
                int dupl_c = count("dupl", code);
                int exclude_c = count("exclude", code);
                int include_c = count("include", code);
                int more_c = count("more", code);
                int or_c = count("or", code);
                int star_c = count("star", code);
                int len = code.size();
                out.push(new int[] {ask_c, cat_c, dupl_c, exclude_c, include_c, more_c, or_c, star_c, len, (int)cost});
            } catch(Exception e) {
                err_counts += 1;
                System.out.println(total + ": " + line);
                System.out.println(e.toString());
                System.out.println();
            }
        }
        System.out.println("total " + total + " err " + err_counts);

        Iterator<int[]> it = out.iterator();
        while (it.hasNext()) {
            int[] row = it.next();
            for (int i = 0; i < row.length; i ++) {
                if (i != 0) {
                    System.out.print(",");
                }
                System.out.print(row[i]);
            }
            System.out.print("\n");
        }
    }

    private static int count(Object cmd, LinkedList<Object> codes) {
        int len = codes.size();
        int ret = 0;
        Iterator it = codes.iterator();
        while (it.hasNext()) {
            if (cmd.equals(it.next())) {
                ret += 1;
            }
        }
        return ret;
    }
}
