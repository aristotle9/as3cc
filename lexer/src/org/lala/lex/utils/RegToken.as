package org.lala.lex.utils
{
    public final class RegToken
    {
        public static const STAR:uint = 0;
        public static const MORE:uint = STAR + 1;
        public static const ASK:uint = MORE + 1;
        public static const CAT:uint = ASK + 1;
        public static const OR:uint = CAT + 1;
        public static const RANGE:uint = OR + 1;
        public static const BOR:uint = RANGE + 1;
        public static const BNOT:uint = BOR + 1;
        public static const LP:uint = BNOT + 1;
        public static const RP:uint = LP + 1;
        public static const LB:uint = RP + 1;
        public static const RB:uint = LB + 1;
        public static const CHAR:uint = RB + 1;
        public static const DOT:uint = CHAR + 1;
        public static const DIGIT:uint = DOT + 1;
        public static const SPACE:uint = DIGIT + 1;
        public static const WORD:uint = SPACE + 1;
        public static const NUM:uint = WORD + 1;
        public static const END:uint = NUM + 1;
        public static const CATCHAS:uint = END + 1;
        
        public static const TKSTAR:RegToken = new RegToken("*", STAR);
        public static const TKMORE:RegToken = new RegToken("+", MORE);
        public static const TKASK:RegToken = new RegToken("?", ASK);
        public static const TKCAT:RegToken = new RegToken("", CAT);
        public static const TKOR:RegToken = new RegToken("|", OR);
        public static const TKLP:RegToken = new RegToken("(", LP);
        public static const TKRP:RegToken = new RegToken(")", RP);
        public static const TKEND:RegToken = new RegToken("#", END);
        public static const TKLB:RegToken = new RegToken("[", LB);
        public static const TKRB:RegToken = new RegToken("]", RB);
        public static const TKRANGE:RegToken = new RegToken("-", RANGE);
        public static const TKBOR:RegToken = new RegToken("|", BOR);
        public static const TKBNOT:RegToken = new RegToken("^", BNOT);
        public static const TKCATCHAS:RegToken = new RegToken("(", CATCHAS);
        public static const TKDOT:RegToken = new RegToken(".", DOT);
        public static const TKDIGIT:RegToken = new RegToken("d", DIGIT);
        public static const TKSPACE:RegToken = new RegToken("s", SPACE);
        public static const TKWORD:RegToken = new RegToken("w", WORD);
        
        /** 没有给出转换的符号是辅助性质的,在分词时,或者解析为后缀结构时加入 **/
        public static function getToken(char:String):RegToken
        {
            switch(char)
            {
                case '*':
                    return TKSTAR;
                case '+':
                    return TKMORE;
                case '?':
                    return TKASK;
                case '|':
                    return TKOR;
                case '(':
                    return TKLP;
                case ')':
                    return TKRP;
                case '[':
                    return TKLB;
                case ']':
                    return TKRB;
                case '-':
                    return TKRANGE;
                case '^':
                    return TKBNOT;
                case '.':
                    return TKDOT;
                default:
                    return new RegToken(char, CHAR);
            }
        }
        /********************************/
        public function get char():String
        {
            return _char;
        }
        
        public function get type():uint
        {
            return _type;
        }
        private var _char:String;
        private var _type:uint;
        public function RegToken(char:String, type:uint)
        {
            _char = char;
            _type = type;
        }
        public function toString():String
        {
            switch(_type)
            {
                case STAR:
                    return "[STAR]";
                    break;
                case MORE:
                    return "[MORE]";
                    break;
                case ASK:
                    return "[ASK]";
                    break;
                case CAT:
                    return "[CAT]";
                    break;
                case OR:
                    return "[OR]";
                    break;
                case CHAR:
                    return "[CHAR:" + char + ']';
                    break;
                case LP:
                    return "[LP]";
                    break;
                case RP:
                    return "[RP]";
                    break;
                case END:
                    return "[END]";
                    break;
                case LB:
                    return "[LB]";
                    break;
                case RB:
                    return "[RB]";
                    break;
                case BOR:
                    return "[BOR]";
                    break;
                case RANGE:
                    return "[RANGE]";
                    break;
                case BNOT:
                    return "[BNOT]";
                    break;
                case CATCHAS:
                    return "[CATCHAS]";
                    break;
                case DOT:
                    return "[DOT]";
                    break;
                case DIGIT:
                    return "[DIGIT]";
                    break;
                case SPACE:
                    return "[SPACE]";
                    break;
                case WORD:
                    return "[WORD]";
                    break;
                case NUM:
                    return "[NUM:" + _char + "]";
                    break;
            }
            return "[" + _type + "]";
        }
    }
}