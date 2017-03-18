extern crate rustc_serialize;

use self::rustc_serialize::json::Json;

use lexer::RegexLexer;
use lexer::RegexLexerError;



type Token = usize;
type State = usize;
type ProdIndex = usize;

#[derive(Debug)]
struct ProductionItem {
    header_id: usize,
    body_length: usize,
}

#[derive(Debug, Copy, Clone)]
enum Action {
    Reduce(ProdIndex),
    Shift(State),
    Accept,
    Goto(State),
    Error,
}

#[derive(Debug)]
pub struct Parser {
    prod_list: Vec<ProductionItem>,
    lookup_table: Vec<Action>,
    lookup_index: Vec<usize>,
}

impl Parser {
    pub fn new() -> Parser {
        Parser {
            prod_list: vec![ProductionItem {
                                header_id: 25,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 19,
                                body_length: 1,
                            },
                            ProductionItem {
                                header_id: 19,
                                body_length: 4,
                            },
                            ProductionItem {
                                header_id: 21,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 21,
                                body_length: 0,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 3,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 3,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 3,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 4,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 20,
                                body_length: 1,
                            },
                            ProductionItem {
                                header_id: 23,
                                body_length: 3,
                            },
                            ProductionItem {
                                header_id: 23,
                                body_length: 4,
                            },
                            ProductionItem {
                                header_id: 23,
                                body_length: 5,
                            },
                            ProductionItem {
                                header_id: 23,
                                body_length: 4,
                            },
                            ProductionItem {
                                header_id: 24,
                                body_length: 4,
                            },
                            ProductionItem {
                                header_id: 24,
                                body_length: 2,
                            },
                            ProductionItem {
                                header_id: 24,
                                body_length: 1,
                            },
                            ProductionItem {
                                header_id: 24,
                                body_length: 3,
                            },
                            ProductionItem {
                                header_id: 22,
                                body_length: 1,
                            },
                            ProductionItem {
                                header_id: 22,
                                body_length: 1,
                            }],
            lookup_index: vec![4, 5, 6, 7, 8, 16, 17, 18, 20, 21, 22, 23, 26, 29, 32, 33, 36, 39,
                               42, 43, 44, 45, 46, 47, 49, 50, 52, 53, 54, 55, 60, 61, 62, 63, 65,
                               66, 68, 71, 74, 78, 81, 87, 88, 89, 94, 95, 98, 100, 106, 107, 108,
                               110, 111, 113, 116, 119, 123, 126, 132, 133, 134, 139, 140, 142,
                               143, 144, 145, 151, 152, 153, 155, 156, 158, 161, 164, 168, 171,
                               177, 178, 179, 184, 185, 187, 188, 189, 190, 196, 197, 198, 200,
                               201, 203, 206, 209, 213, 216, 222, 223, 224, 244, 255, 282, 297,
                               315, 319, 320, 323, 324, 331, 332, 333, 335, 336, 338, 341, 344,
                               348, 351, 357, 358, 359, 364, 365, 367, 368, 369, 370, 376, 377,
                               378, 380, 381, 383, 386, 389, 393, 396, 402, 403, 404, 405, 406,
                               407, 409, 410, 412, 413, 414, 415, 420, 421, 422, 423, 425, 426,
                               428, 431, 434, 438, 441, 447, 448, 449, 455, 462, 463, 464, 474,
                               477, 478, 484, 490, 498, 540, 541, 542, 543, 544, 545, 547, 548,
                               549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 560, 561, 562,
                               563, 564, 565, 566, 567, 568, 569, 572, 573, 574, 575, 576, 579,
                               580, 582, 583, 584, 604, 616, 622, 630, 631, 632, 633, 634, 635,
                               637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 650,
                               651, 652, 653, 654, 656, 657, 658, 659, 662, 663, 664, 666, 669,
                               670, 672, 673, 674, 679, 680, 682, 683, 684, 685, 691, 692, 693,
                               695, 696, 698, 701, 704, 708, 711, 717, 718, 719, 724, 725, 727,
                               728, 729, 730, 736, 737, 738, 740, 741, 743, 746, 749, 753, 756,
                               762, 763, 764, 795, 802, 803, 806, 855, 900, 901, 902, 907, 909,
                               910, 915, 920, 929, 967, 990, 991, 992, 993, 997, 999, 1000, 1001,
                               1004, 1005, 1010, 1014, 1019, 1022, 1042, 1044, 1045, 1055, 1064,
                               1083, 1091],
            lookup_table: vec![Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Accept,
                               Action::Reduce(1),
                               Action::Reduce(14),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(4),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Reduce(5),
                               Action::Reduce(2),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(3),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Shift(2),
                               Action::Shift(2),
                               Action::Shift(2),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(2),
                               Action::Reduce(14),
                               Action::Shift(2),
                               Action::Shift(2),
                               Action::Shift(2),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(2),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Reduce(14),
                               Action::Shift(23),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Reduce(5),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(16),
                               Action::Reduce(14),
                               Action::Shift(16),
                               Action::Shift(16),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Shift(16),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(16),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(17),
                               Action::Reduce(14),
                               Action::Shift(17),
                               Action::Shift(17),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Shift(17),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(17),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Shift(31),
                               Action::Shift(37),
                               Action::Shift(25),
                               Action::Shift(35),
                               Action::Shift(1),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Reduce(14),
                               Action::Shift(22),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Reduce(5),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(18),
                               Action::Reduce(14),
                               Action::Shift(18),
                               Action::Shift(18),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Shift(18),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(18),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Shift(3),
                               Action::Shift(3),
                               Action::Shift(3),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(3),
                               Action::Reduce(14),
                               Action::Shift(3),
                               Action::Shift(3),
                               Action::Shift(3),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(3),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(24),
                               Action::Reduce(23),
                               Action::Reduce(21),
                               Action::Shift(26),
                               Action::Shift(33),
                               Action::Reduce(23),
                               Action::Reduce(20),
                               Action::Reduce(22),
                               Action::Reduce(19),
                               Action::Shift(11),
                               Action::Shift(4),
                               Action::Shift(4),
                               Action::Shift(4),
                               Action::Shift(12),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(4),
                               Action::Reduce(14),
                               Action::Shift(4),
                               Action::Shift(4),
                               Action::Shift(12),
                               Action::Reduce(23),
                               Action::Reduce(21),
                               Action::Shift(27),
                               Action::Shift(4),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(4),
                               Action::Reduce(6),
                               Action::Shift(27),
                               Action::Shift(34),
                               Action::Reduce(11),
                               Action::Reduce(23),
                               Action::Reduce(20),
                               Action::Shift(4),
                               Action::Shift(4),
                               Action::Reduce(12),
                               Action::Reduce(22),
                               Action::Shift(40),
                               Action::Reduce(15),
                               Action::Reduce(3),
                               Action::Reduce(19),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Shift(30),
                               Action::Shift(38),
                               Action::Shift(41),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(5),
                               Action::Reduce(14),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Reduce(23),
                               Action::Reduce(21),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(4),
                               Action::Reduce(6),
                               Action::Shift(5),
                               Action::Reduce(11),
                               Action::Reduce(23),
                               Action::Reduce(20),
                               Action::Shift(5),
                               Action::Shift(5),
                               Action::Reduce(12),
                               Action::Reduce(22),
                               Action::Reduce(15),
                               Action::Reduce(3),
                               Action::Reduce(19),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(19),
                               Action::Reduce(14),
                               Action::Shift(19),
                               Action::Shift(19),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Shift(19),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Shift(19),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Reduce(23),
                               Action::Reduce(24),
                               Action::Shift(15),
                               Action::Reduce(14),
                               Action::Shift(15),
                               Action::Shift(15),
                               Action::Reduce(8),
                               Action::Reduce(9),
                               Action::Reduce(10),
                               Action::Reduce(13),
                               Action::Reduce(7),
                               Action::Reduce(6),
                               Action::Reduce(11),
                               Action::Reduce(5),
                               Action::Reduce(12),
                               Action::Reduce(15),
                               Action::Reduce(18),
                               Action::Reduce(16),
                               Action::Reduce(17),
                               Action::Shift(36),
                               Action::Shift(42),
                               Action::Shift(43),
                               Action::Shift(44),
                               Action::Goto(6),
                               Action::Goto(7),
                               Action::Goto(9),
                               Action::Goto(10),
                               Action::Goto(20),
                               Action::Goto(20),
                               Action::Goto(20),
                               Action::Goto(29),
                               Action::Goto(20),
                               Action::Goto(20),
                               Action::Goto(32),
                               Action::Goto(8),
                               Action::Goto(8),
                               Action::Goto(8),
                               Action::Goto(13),
                               Action::Goto(8),
                               Action::Goto(8),
                               Action::Goto(8),
                               Action::Goto(13),
                               Action::Goto(28),
                               Action::Goto(8),
                               Action::Goto(8),
                               Action::Goto(28),
                               Action::Goto(8),
                               Action::Goto(39),
                               Action::Goto(21),
                               Action::Goto(21),
                               Action::Goto(21),
                               Action::Goto(21),
                               Action::Goto(21),
                               Action::Goto(14),
                               Action::Goto(24)],
        }
    }

    fn lookup(&self, token: Token, state: State) -> Action {
        let input_length: usize = 25;
        let state_length: usize = 45;
        if token >= input_length || state >= state_length {
            return Action::Error;
        }
        self.find(token * state_length + state)
    }

    fn find(&self, value: usize) -> Action {
        let mut left: usize = 0;
        let mut right: usize = self.lookup_index.len();
        let mut old_mid: usize = 0;
        loop {
            let mut mid = (left + right) >> 1;
            let index_value = self.lookup_index[mid];
            if index_value == value {
                return self.lookup_table[mid].clone();
            } else if index_value > value {
                right = mid;
            } else {
                left = mid;
            }

            if old_mid == mid {
                return Action::Error;
            } else {
                old_mid = mid;
            }
        }
        Action::Error
    }

    pub fn parse(&self, lexer: &mut RegexLexer) -> Result<Json, RegexLexerError> {

        let mut codes: Vec<Json> = Vec::new();
        let mut flags: Vec<Json> = Vec::new();

        let mut state_stack: Vec<State> = vec![0];
        let mut output_stack: Vec<Json> = Vec::new();

        loop {
            let token = match lexer.get_token() {
                Ok(token) => token,
                Err(err) => return Err(err),
            };
            let state = state_stack[state_stack.len() - 1];
            let action = self.lookup(token, state);
            // println!("{:?}", ("cur_state", state, "token", RegexLexer::find_token_name(token), token, lexer.get_yytext(), "action", action));
            match action {
                Action::Accept => {
                    return Ok(output_stack.pop().unwrap());
                }
                Action::Shift(next_state) => {
                    output_stack.push(lexer.get_yytext());
                    state_stack.push(next_state);
                    lexer.advance();
                }
                Action::Reduce(prod_index) => {
                    let length = self.prod_list[prod_index].body_length;
                    let mut _result: Option<Json> = None;
                    match prod_index {
                        0x1 => {
                            _result = Some(Json::Array(codes.clone()));
                        }
                        0x2 => {

                            for _ in 0..flags.len() {
                                codes.pop();
                            }
                            _result = Some(Json::Array(codes.clone()));

                        }
                        0x3 => {

                            let flags_c = (output_stack[output_stack.len() - 1].clone());
                            if flags.contains(&flags_c) {
                                return Err(lexer.new_lexer_error("Flag Repeated".to_string()));
                            }
                            if "igm".find(flags_c.as_string().unwrap()).is_none() {
                                return Err(lexer.new_lexer_error("Unknow Flag".to_string()));
                            }
                            flags.push(flags_c);

                        }
                        0x4 => {}
                        0x5 => {
                            codes.push(Json::String("or".to_string()));
                        }
                        0x6 => {}
                        0x7 => {}
                        0x8 => {
                            codes.push(Json::String("star".to_string()));
                        }
                        0x9 => {
                            codes.push(Json::String("more".to_string()));
                        }
                        0xA => {
                            codes.push(Json::String("ask".to_string()));
                        }
                        0xB => {
                            codes.push(Json::Array(vec![Json::String("include".to_string()),
                                                        (output_stack[output_stack.len() - 2]
                                                            .clone())]));
                        }
                        0xC => {
                            codes.push(Json::Array(vec![Json::String("exclude".to_string()),
                                                        (output_stack[output_stack.len() - 2]
                                                            .clone())]));
                        }
                        0xD => {
                            codes.push(Json::String("cat".to_string()));
                        }
                        0xE => {
                            codes.push(Json::String("single".to_string()));
                        }
                        0xF => {

                            let n: u64 = (output_stack[output_stack.len() - 2].clone())
                                .as_u64()
                                .unwrap() - 1;
                            for _ in 0..n {
                                codes.push(Json::String("dupl".to_string()));
                            }
                            for _ in 0..n {
                                codes.push(Json::String("cat".to_string()));
                            }

                        }
                        0x10 => {

                            codes.push(Json::String("ask".to_string()));
                            let n: u64 = (output_stack[output_stack.len() - 2].clone())
                                .as_u64()
                                .unwrap() - 1;
                            for _ in 0..n {
                                codes.push(Json::String("dupl".to_string()));
                            }
                            for _ in 0..n {
                                codes.push(Json::String("cat".to_string()));
                            }

                        }
                        0x11 => {

                            let mut n: u64 = (output_stack[output_stack.len() - 4].clone())
                                .as_u64()
                                .unwrap() - 1;
                            for _ in 0..n {
                                codes.push(Json::String("dupl".to_string()));
                            }
                            n = (output_stack[output_stack.len() - 2].clone()).as_u64().unwrap() -
                                n;
                            if n > 0 {
                                codes.push(Json::String("dupl".to_string()));
                                codes.push(Json::String("ask".to_string()));
                                for _ in 0..n {
                                    codes.push(Json::String("dupl".to_string()));
                                }
                            }
                            n = (output_stack[output_stack.len() - 2].clone()).as_u64().unwrap() -
                                1;
                            for _ in 0..n {
                                codes.push(Json::String("cat".to_string()));
                            }

                        }
                        0x12 => {

                            let n: u64 =
                                (output_stack[output_stack.len() - 3].clone()).as_u64().unwrap();
                            for _ in 0..n {
                                codes.push(Json::String("dupl".to_string()));
                            }
                            codes.push(Json::String("star".to_string()));
                            for _ in 0..n {
                                codes.push(Json::String("cat".to_string()));
                            }

                        }
                        0x13 => {
                            _result =
                                Some(Json::U64((output_stack[output_stack.len() - 4].clone())
                                    .as_u64()
                                    .unwrap() + 1));
                            codes.push(Json::Array(vec![Json::String("c".to_string()),
                                                        (output_stack[output_stack.len() - 3]
                                                            .clone())]));
                            codes.push(Json::Array(vec![Json::String("c".to_string()),
                                                        (output_stack[output_stack.len() - 1]
                                                            .clone())]));
                            codes.push(Json::String("range".to_string()));
                        }
                        0x14 => {
                            _result =
                                Some(Json::U64((output_stack[output_stack.len() - 2].clone())
                                    .as_u64()
                                    .unwrap() + 1));
                            codes.push(Json::String("single".to_string()));
                        }
                        0x15 => {
                            codes.push(Json::String("single".to_string()));
                            _result = Some(Json::U64(1));
                        }
                        0x16 => {
                            codes.push(Json::Array(vec![Json::String("c".to_string()),
                                                        (output_stack[output_stack.len() - 3]
                                                            .clone())]));
                            codes.push(Json::Array(vec![Json::String("c".to_string()),
                                                        (output_stack[output_stack.len() - 1]
                                                            .clone())]));
                            codes.push(Json::String("range".to_string()));
                            _result = Some(Json::U64(1));
                        }
                        0x17 => {
                            codes.push(Json::Array(vec![Json::String("c".to_string()),
                                                        (output_stack[output_stack.len() - 1]
                                                            .clone())]));
                        }
                        0x18 => {

                            if (output_stack[output_stack.len() - 1].clone())
                                .as_string()
                                .unwrap() == "\\c" {
                                return Err(lexer.new_lexer_error("Control Character".to_string()));
                            }
                            codes.push(Json::Array(vec![Json::String("escc".to_string()),
                                                        (output_stack[output_stack.len() - 1]
                                                            .clone())]));

                        }
                        _ => {}
                    };
                    if length > 0 && _result.is_none() {
                        _result = Some(output_stack[output_stack.len() - length].clone());
                    }
                    if _result.is_none() {
                        _result = Some(Json::Null);
                    }
                    {
                        let mut i = 0;
                        while i < length {
                            state_stack.pop();
                            output_stack.pop();
                            i += 1;
                        }
                    }
                    let next_state = state_stack[state_stack.len() - 1];
                    let next_action = self.lookup(self.prod_list[prod_index].header_id, next_state);
                    match next_action {
                        Action::Goto(next_state) => {
                            state_stack.push(next_state);
                            output_stack.push(_result.unwrap());
                        }
                        _ => return Err(lexer.new_lexer_error("Goto Error".to_string())),
                    };
                }
                _ => {
                    return Err(lexer.new_lexer_error("Parser Error".to_string()));
                }
            }
        }
        Ok(Json::Null)
    }

    pub fn parse_str(source: &str) -> Result<Json, RegexLexerError> {
        let mut lexer = RegexLexer::new();
        lexer.set_source(source);
        let mut p = Self::new();
        p.parse(&mut lexer)
    }
}
