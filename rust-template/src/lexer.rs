extern crate rustc_serialize;

use self::rustc_serialize::json::Json;

use std::error::Error;
use std::fmt;
use std::u64;


use std::char;


/**
 * Created by as3cc on Fri Jan 6 00:17:09 GMT+0800 2017.
 */
type TransTable = Vec<RangeItem>;
type Token = usize;
type RegexLexerResult = Result<Token, RegexLexerError>;
const DEADSTATE: usize = 0xffffffff;
const END_TOKEN: usize = 0;


#[derive(Debug)]
pub struct RegexLexerError {
    token_name: &'static str,
    token_index: usize,
    line: u64,
    col: u64,
    reason: String,
}

impl fmt::Display for RegexLexerError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f,
               "RegexLexerError: {} {}@row:{}col:{}",
               self.reason,
               self.token_name,
               self.line,
               self.col)
    }
}

impl Error for RegexLexerError {
    fn description(&self) -> &str {
        &self.reason
    }
}

#[derive(Debug)]
struct StateTransItem {
    is_dead: bool,
    final_index: i64,
    to_states: Vec<usize>,
    trans_edge: TransTable,
}

#[derive(Debug)]
struct RangeItem {
    from: u64,
    to: u64,
    value: u64,
}

#[derive(Debug)]
pub struct RegexLexer {
    trans_table: Vec<StateTransItem>,
    input_table: TransTable,
    _start: usize,
    _old_start: usize,
    _token_index: usize,
    _yytext: Json,
    _yy: usize, //&mut u8
    _ended: bool,
    _initial_input: usize,
    _line: u64,
    _col: u64,
    _advanced: bool,
    _source: Vec<char>, //
}

impl RegexLexer {
    pub fn find_token_name(token_index: usize) -> &'static str {
        return match token_index {
            0 => "<$>",
            1 => "(",
            2 => ")",
            3 => "*",
            4 => "+",
            5 => ",",
            6 => "-",
            7 => "/",
            8 => "?",
            9 => "[",
            10 => "]",
            11 => "^",
            12 => "c",
            13 => "d",
            14 => "escc",
            15 => "{",
            16 => "|",
            17 => "}",
            _ => "<undefined_token>",
        };
    }

    pub fn find_initial_name(initial_input: u64) -> &'static str {
        return match initial_input {
            1 => "REPEAT",
            2 => "BRACKET",
            3 => "INITIAL",
            _ => "undefined initial input",
        };
    }

    #[inline]
    pub fn is_end_token(token: usize) -> bool {
        token == END_TOKEN
    }

    pub fn new() -> RegexLexer {
;        let _trans_table =
            vec![StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 3, 2, 1],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 32,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 33,
                                          to: 33,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 34,
                                          to: 34,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 35,
                                          to: 35,
                                          value: 3,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 0,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 1,
                                          to: 1,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 2,
                                          to: 2,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 3,
                                          to: 3,
                                          value: 3,
                                      },
                                      RangeItem {
                                          from: 4,
                                          to: 4,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 5,
                                          to: 5,
                                          value: 5,
                                      },
                                      RangeItem {
                                          from: 6,
                                          to: 6,
                                          value: 6,
                                      },
                                      RangeItem {
                                          from: 7,
                                          to: 7,
                                          value: 7,
                                      },
                                      RangeItem {
                                          from: 8,
                                          to: 28,
                                          value: 8,
                                      },
                                      RangeItem {
                                          from: 29,
                                          to: 29,
                                          value: 9,
                                      },
                                      RangeItem {
                                          from: 30,
                                          to: 30,
                                          value: 10,
                                      },
                                      RangeItem {
                                          from: 31,
                                          to: 31,
                                          value: 11,
                                      },
                                      RangeItem {
                                          from: 32,
                                          to: 32,
                                          value: 12,
                                      },
                                      RangeItem {
                                          from: 33,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 15, 14, 13, 8, 18, 17, 16],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 0,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 1,
                                          to: 1,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 2,
                                          to: 2,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 3,
                                          to: 3,
                                          value: 3,
                                      },
                                      RangeItem {
                                          from: 4,
                                          to: 7,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 8,
                                          to: 8,
                                          value: 5,
                                      },
                                      RangeItem {
                                          from: 9,
                                          to: 9,
                                          value: 6,
                                      },
                                      RangeItem {
                                          from: 10,
                                          to: 27,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 28,
                                          to: 28,
                                          value: 7,
                                      },
                                      RangeItem {
                                          from: 29,
                                          to: 32,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 33,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 22, 21, 20, 19],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 25,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 26,
                                          to: 26,
                                          value: 3,
                                      },
                                      RangeItem {
                                          from: 27,
                                          to: 27,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 28,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 0,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 4,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 1,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 2,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 28,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 3,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 6,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 5,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 10,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 28,
                     to_states: vec![4294967295, 31, 23, 14, 29, 28, 27, 26, 25, 30, 33, 32, 24],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 0,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 1,
                                          to: 1,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 2,
                                          to: 9,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 10,
                                          to: 11,
                                          value: 3,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 4,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 13,
                                          value: 5,
                                      },
                                      RangeItem {
                                          from: 14,
                                          to: 14,
                                          value: 6,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 15,
                                          value: 7,
                                      },
                                      RangeItem {
                                          from: 16,
                                          to: 16,
                                          value: 8,
                                      },
                                      RangeItem {
                                          from: 17,
                                          to: 18,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 9,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 10,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 11,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 23,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 24,
                                          to: 24,
                                          value: 12,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 32,
                                          value: 2,
                                      },
                                      RangeItem {
                                          from: 33,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 18,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 27,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 8,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 7,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 9,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 14,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 13,
                     to_states: vec![4294967295, 20],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 25,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 26,
                                          to: 26,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 27,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 11,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 12,
                     to_states: vec![4294967295, 22],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 26,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 26,
                     to_states: vec![4294967295, 34],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 22,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 23,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 26,
                     to_states: vec![4294967295, 35],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 26,
                     to_states: vec![4294967295, 36],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 22,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 23,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 19,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 21,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 24,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 20,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 25,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 37],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 22,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 23,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 38],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 39],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 15,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 16,
                     to_states: vec![],
                     trans_edge: vec![],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 40],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: false,
                     final_index: 4294967295,
                     to_states: vec![4294967295, 41],
                     trans_edge: vec![RangeItem {
                                          from: 0,
                                          to: 10,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 11,
                                          to: 11,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 12,
                                          to: 12,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 13,
                                          to: 14,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 15,
                                          to: 17,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 18,
                                          to: 18,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 19,
                                          to: 19,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 20,
                                          to: 20,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 21,
                                          to: 21,
                                          value: 0,
                                      },
                                      RangeItem {
                                          from: 22,
                                          to: 24,
                                          value: 1,
                                      },
                                      RangeItem {
                                          from: 25,
                                          to: 35,
                                          value: 0,
                                      }],
                 },
                 StateTransItem {
                     is_dead: true,
                     final_index: 17,
                     to_states: vec![],
                     trans_edge: vec![],
                 }];
        let _input_table = vec![RangeItem {
                                    from: 0,
                                    to: 8,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 9,
                                    to: 9,
                                    value: 26,
                                },
                                RangeItem {
                                    from: 10,
                                    to: 10,
                                    value: 0,
                                },
                                RangeItem {
                                    from: 11,
                                    to: 12,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 13,
                                    to: 13,
                                    value: 0,
                                },
                                RangeItem {
                                    from: 14,
                                    to: 31,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 32,
                                    to: 32,
                                    value: 26,
                                },
                                RangeItem {
                                    from: 33,
                                    to: 39,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 40,
                                    to: 40,
                                    value: 31,
                                },
                                RangeItem {
                                    from: 41,
                                    to: 41,
                                    value: 5,
                                },
                                RangeItem {
                                    from: 42,
                                    to: 42,
                                    value: 32,
                                },
                                RangeItem {
                                    from: 43,
                                    to: 43,
                                    value: 30,
                                },
                                RangeItem {
                                    from: 44,
                                    to: 44,
                                    value: 25,
                                },
                                RangeItem {
                                    from: 45,
                                    to: 45,
                                    value: 28,
                                },
                                RangeItem {
                                    from: 46,
                                    to: 46,
                                    value: 2,
                                },
                                RangeItem {
                                    from: 47,
                                    to: 47,
                                    value: 1,
                                },
                                RangeItem {
                                    from: 48,
                                    to: 48,
                                    value: 24,
                                },
                                RangeItem {
                                    from: 49,
                                    to: 55,
                                    value: 23,
                                },
                                RangeItem {
                                    from: 56,
                                    to: 57,
                                    value: 22,
                                },
                                RangeItem {
                                    from: 58,
                                    to: 62,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 63,
                                    to: 63,
                                    value: 29,
                                },
                                RangeItem {
                                    from: 64,
                                    to: 64,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 65,
                                    to: 70,
                                    value: 18,
                                },
                                RangeItem {
                                    from: 71,
                                    to: 90,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 91,
                                    to: 91,
                                    value: 6,
                                },
                                RangeItem {
                                    from: 92,
                                    to: 92,
                                    value: 3,
                                },
                                RangeItem {
                                    from: 93,
                                    to: 93,
                                    value: 8,
                                },
                                RangeItem {
                                    from: 94,
                                    to: 94,
                                    value: 9,
                                },
                                RangeItem {
                                    from: 95,
                                    to: 96,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 97,
                                    to: 97,
                                    value: 18,
                                },
                                RangeItem {
                                    from: 98,
                                    to: 98,
                                    value: 14,
                                },
                                RangeItem {
                                    from: 99,
                                    to: 99,
                                    value: 20,
                                },
                                RangeItem {
                                    from: 100,
                                    to: 100,
                                    value: 11,
                                },
                                RangeItem {
                                    from: 101,
                                    to: 101,
                                    value: 18,
                                },
                                RangeItem {
                                    from: 102,
                                    to: 102,
                                    value: 13,
                                },
                                RangeItem {
                                    from: 103,
                                    to: 109,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 110,
                                    to: 110,
                                    value: 21,
                                },
                                RangeItem {
                                    from: 111,
                                    to: 113,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 114,
                                    to: 114,
                                    value: 12,
                                },
                                RangeItem {
                                    from: 115,
                                    to: 115,
                                    value: 10,
                                },
                                RangeItem {
                                    from: 116,
                                    to: 116,
                                    value: 19,
                                },
                                RangeItem {
                                    from: 117,
                                    to: 117,
                                    value: 15,
                                },
                                RangeItem {
                                    from: 118,
                                    to: 118,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 119,
                                    to: 119,
                                    value: 10,
                                },
                                RangeItem {
                                    from: 120,
                                    to: 120,
                                    value: 16,
                                },
                                RangeItem {
                                    from: 121,
                                    to: 122,
                                    value: 17,
                                },
                                RangeItem {
                                    from: 123,
                                    to: 123,
                                    value: 4,
                                },
                                RangeItem {
                                    from: 124,
                                    to: 124,
                                    value: 7,
                                },
                                RangeItem {
                                    from: 125,
                                    to: 125,
                                    value: 27,
                                },
                                RangeItem {
                                    from: 126,
                                    to: 65535,
                                    value: 17,
                                }];
        RegexLexer {
            trans_table: _trans_table,
            input_table: _input_table,
            _start: 0,
            _old_start: 0,
            _token_index: 0,
            _yytext: Json::Null,
            _yy: 0,
            _ended: false,
            _initial_input: 3,
            _line: 0,
            _col: 0,
            _advanced: true,
            _source: vec![],
        }
    }

    fn restart(&mut self, source: &str) {
        self._ended = false;
        self._start = 0;
        self._old_start = 0;
        self._line = 0;
        self._col = 0;
        self._advanced = true;
        self._token_index = 0;
        self._yytext = Json::Null;
        self._yy = 0;
        self._initial_input = 3;
        self._source = source.chars().collect();
;

    }

    #[inline]
    pub fn set_source(&mut self, source: &str) {
        self.restart(source);
    }

    #[inline]
    pub fn advance(&mut self) {
        self._advanced = true;
    }

    #[inline]
    pub fn start_index(&self) -> usize {
        self._old_start
    }

    #[inline]
    pub fn end_index(&self) -> usize {
        self._start
    }

    #[inline]
    pub fn get_position(&self) -> [u64; 2] {
        [self._line, self._col]
    }

    #[inline]
    pub fn new_lexer_error(&self, reason: String) -> RegexLexerError {
        // format!("{}@row:{}col:{}", Self::find_token_name(self._token_index), self._line, self._col)
        RegexLexerError {
            token_name: Self::find_token_name(self._token_index),
            token_index: self._token_index,
            line: self._line,
            col: self._col,
            reason: reason,
        }
    }

    #[inline]
    fn set_yytext(&mut self, value: Json) {
        self._yytext = value;
    }

    #[inline]
    pub fn get_yytext(&mut self) -> Json {
        if self._yytext.is_null() && !self._ended {
            self._yytext = Json::String(self._source[self.start_index()..self.end_index()]
                .iter()
                .cloned()
                .collect())
        }
        self._yytext.clone()
    }

    #[inline]
    fn get_token_index(&self) -> usize {
        self._token_index
    }

    #[inline]
    fn begin(&mut self, initial_input: usize) {
        self._initial_input = initial_input;
    }

    pub fn get_token(&mut self) -> RegexLexerResult {
        if self._advanced {
            match self.next() {
                Ok(value) => {
                    self._token_index = value;
                }
                Err(err) => {
                    return Err(err);
                }
            };
            self._advanced = false;
        }
        Ok(self._token_index)
    }

    fn next(&mut self) -> RegexLexerResult {
        loop {
            let mut _next_state: usize = 0;
            let mut _ch: u64 = 0;
            let mut _next: usize = self._start;
            let mut _och: u64 = u64::MAX;
            let mut _cur_state: usize = self.trans_table[0].to_states[self._initial_input];
            let mut _last_final_state = DEADSTATE;
            let mut _last_final_position = self._start;
            loop {
                if _next < self._source.len() {
                    _ch = self._source[_next] as u64;
                    // 计算行列位置
                    if _och != u64::MAX {
                        if _ch == 0x0d {
                            //\r
                            self._col = 0;
                            self._line += 1;
                        } else if _ch == 0x0a {
                            //\n
                            if _och != 0x0d {
                                //\r
                                self._col = 0;
                                self._line += 1;
                            }
                        } else {
                            self._col += 1;
                        }
                    }

                    _och = _ch;
                    _next_state = match self.trans(_cur_state, _ch) {
                        Ok(st) => st,
                        Err(err) => {
                            return Err(err);
                        }
                    };
                } else {
                    _next_state = DEADSTATE;
                }

                if _next_state == DEADSTATE {
                    if self._start == _last_final_position {
                        if self._start == self._source.len() {
                            if !self._ended {
                                self._ended = true;
                                return Ok(END_TOKEN);
                            } else {
                                return Err(self.new_lexer_error("aleady at end.".to_string()));
                            }
                        } else {
                            return Err(self.new_lexer_error("invalid char".to_string()));
                        }
                    } else {
                        self._yytext = Json::Null;//set yytext
                        self._old_start = self._start;
                        self._start = _last_final_position;
                        let _findex = self.trans_table[_last_final_state].final_index;
                        match _findex {
                            0x0 => {
                                return Ok(3) /* * */ ;
                            }
                            0x1 => {
                                return Ok(4) /* + */ ;
                            }
                            0x2 => {
                                return Ok(8) /* ? */ ;
                            }
                            0x3 => {
                                return Ok(16) /* | */ ;
                            }
                            0x4 => {
                                return Ok(1) /* ( */ ;
                            }
                            0x5 => {
                                return Ok(2) /* ) */ ;
                            }
                            0x6 => {
                                self.begin(2) /* BRACKET */ ;
                                return Ok(9) /* [ */ ;
                            }
                            0x7 => {
                                return Ok(11) /* ^ */ ;
                            }
                            0x8 => {
                                return Ok(6) /* - */ ;
                            }
                            0x9 => {
                                self.begin(3) /* INITIAL */ ;
                                return Ok(10) /* ] */ ;
                            }
                            0xA => {
                                self.begin(1) /* REPEAT */ ;
                                return Ok(15) /* { */ ;
                            }
                            0xB => {
                                return Ok(5) /* , */ ;
                            }
                            0xC => {
                                {
                                    let u =
                                        u64::from_str_radix(self.get_yytext().as_string().unwrap(),
                                                            10)
                                            .unwrap();
                                    self.set_yytext(Json::U64(u));
                                }
                                return Ok(13) /* d */ ;
                            }
                            0xE => {
                                self.begin(3) /* INITIAL */ ;
                                return Ok(17) /* } */ ;
                            }
                            0xF => {
                                {
                                    let u = u32::from_str_radix(&self.get_yytext().as_string().unwrap()[2 .. 4], 8).unwrap();
                                    self.set_yytext(Json::String(char::from_u32(u)
                                        .unwrap()
                                        .to_string()));
                                }
                                return Ok(12) /* c */ ;
                            }
                            0x10 => {
                                {
                                    let u = u32::from_str_radix(&self.get_yytext().as_string().unwrap()[2 .. 4], 16).unwrap();
                                    self.set_yytext(Json::String(char::from_u32(u)
                                        .unwrap()
                                        .to_string()));
                                }
                                return Ok(12) /* c */ ;
                            }
                            0x11 => {
                                {
                                    let u = u32::from_str_radix(&self.get_yytext().as_string().unwrap()[2 .. 6], 16).unwrap();
                                    self.set_yytext(Json::String(char::from_u32(u)
                                        .unwrap()
                                        .to_string()));
                                }
                                return Ok(12) /* c */ ;
                            }
                            0x12 => {
                                return Ok(14) /* escc */ ;
                            }
                            0x13 => {
                                self.set_yytext(Json::String("\r".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x14 => {
                                self.set_yytext(Json::String("\n".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x15 => {
                                self.set_yytext(Json::String("\t".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x16 => {
                                self.set_yytext(Json::String("\x08".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x17 => {
                                self.set_yytext(Json::String("\x0C".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x18 => {
                                self.set_yytext(Json::String("/".to_string()));
                                return Ok(12) /* c */ ;
                            }
                            0x19 => {
                                return Ok(14) /* escc */ ;
                            }
                            0x1A => {
                                {
                                    let s = self.get_yytext();
                                    self.set_yytext(Json::String(s.as_string().unwrap()[1..]
                                        .to_string()));
                                }
                                return Ok(12) /* c */ ;
                            }
                            0x1B => {
                                return Ok(7) /* / */ ;
                            }
                            0x1C => {
                                return Ok(12) /* c */ ;
                            }
                            _ => {}
                        }
                        break;
                    }
                } else {
                    _next += 1;
                    if self.trans_table[_next_state].final_index != 0xffffffff {
                        _last_final_state = _next_state;
                        _last_final_position = _next;
                    }
                    _cur_state = _next_state;
                }
            }
        }
    }

    fn find(code: u64, table: &TransTable) -> u64 {
        let mut max = table.len();
        let mut min = 0;

        loop {
            let mid = (max + min) >> 1;
            if table[mid].from <= code {
                if table[mid].to >= code {
                    return table[mid].value;
                } else {
                    min = mid + 1;
                }
            } else {
                max = mid - 1;
            }
        }
    }

    fn trans(&self, cur_state: usize, ch: u64) -> RegexLexerResult {
        if ch < self.input_table[0].from || ch > self.input_table[self.input_table.len() - 1].to {
            return Err(self.new_lexer_error("input char out of valid range".to_string()));
        }
        if self.trans_table[cur_state].is_dead {
            return Ok(DEADSTATE);
        }
        let pub_input = Self::find(ch, &self.input_table);
        let inner_input = Self::find(pub_input, &self.trans_table[cur_state].trans_edge);
        return Ok(self.trans_table[cur_state].to_states[inner_input as usize]);
    }

    pub fn lex_seq(source: &str)
                   -> Result<Vec<(&'static str, Token, Json, usize, usize)>, RegexLexerError> {
        //(token_name, token_index, yytext, star, end)
        let mut lexer = RegexLexer::new();
        lexer.set_source(source);
        let mut tokens = Vec::new();
        let mut token: usize = 0;
        match lexer.get_token() {
            Ok(value) => {
                token = value;
            }
            Err(err) => {
                return Err(err);
            }
        };
        while !Self::is_end_token(token) {
            tokens.push((Self::find_token_name(token),
                         token,
                         lexer.get_yytext(),
                         lexer.start_index(),
                         lexer.end_index()));
            lexer.advance();
            match lexer.get_token() {
                Ok(value) => {
                    token = value;
                }
                Err(err) => {
                    return Err(err);
                }
            };
        }
        Ok(tokens)
    }
}
