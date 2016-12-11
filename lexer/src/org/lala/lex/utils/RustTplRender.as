package org.lala.lex.utils
{
    public class RustTplRender
    {
        public function RustTplRender()
        {
        }
        
        public function render(data:Object):String
        {
            var str:String = String(Src);
            return str.replace(/<{\s*(\w+)\s*\}>/g,function(...args):String
            {
                if(data[args[1]] != null)
                {
                    return String(data[args[1]]);
                }
                return '';
            });
        }
		
		private static const Src:String = String(<r><![CDATA[use std::error::Error;
use std::fmt;
use std::u64;
<{ imports }>

/**
 * Created by as3cc on <{ create_date }>.
 */
type TransTable = Vec<RangeItem>;
type Token = usize;
type <{ class }>Result = Result<Token, <{ class }>Error>;
const DEADSTATE: usize = 0xffffffff;
const END_TOKEN: usize = <{ end_token_index }>;


#[derive(Debug)]
pub struct <{ class }>Error {
    token_name: &'static str,
    token_index: usize,
    line: u64,
    col: u64,
    reason: String,
}

impl fmt::Display for <{ class }>Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "<{ class }>Error: {} {}@row:{}col:{}", self.reason, self.token_name, self.line, self.col)
    }
}

impl Error for <{ class }>Error {
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
pub struct <{ class }> {
    trans_table: Vec<StateTransItem>,
    input_table: TransTable,
    _start:  usize,
    _old_start:  usize,
    _token_index:  usize,
    _yytext:  usize,//&mut u8
    _yy:  usize,//&mut u8
    _ended:  bool,
    _initial_input:  usize,
    _line:  u64,
    _col:  u64,
    _advanced:  bool,
    _source:  Vec<char>,//
}

<{ usercode }>

impl <{ class }> {
    
    pub fn find_token_name(token_index: usize) -> &'static str {
        <{ token_name_lookup }>
    }

    pub fn find_initial_name(initial_input: u64) -> &'static str {
        <{ initial_name_lookup }>
    }
    
    #[inline]
    pub fn is_end_token(token: usize) -> bool {
        token == END_TOKEN
    }

    pub fn new() -> <{ class }> {
        <{ tables }>
        <{ class }> {
            trans_table: _trans_table,
            input_table: _input_table,
            _start: 0,
            _old_start: 0,
            _token_index: 0,
            _yytext: 0,
            _yy: 0,
            _ended: false,
            _initial_input: <{ initial_input_index }>,
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
        self._yytext = 0;
        self._yy = 0;
        self._initial_input = <{ initial_input_index }>;
        self._source = source.chars().collect();
        <{ initial }>
    }

    #[inline]
    pub fn set_source(&mut self, source: &str) {
        self.restart(source);
    }

    #[inline]
    fn advance(&mut self) {
        self._advanced = true;
    }

    #[inline]
    fn start_index(&self) -> usize {
        self._old_start
    }

    #[inline]
    fn end_index(&self) -> usize {
        self._start
    }

    #[inline]
    fn get_position(&self) -> [u64; 2] {
        [self._line, self._col]
    }

    #[inline]
    fn new_lexer_error(&self, reason: String) -> <{ class }>Error {
        // format!("{}@row:{}col:{}", Self::find_token_name(self._token_index), self._line, self._col)
        <{ class }>Error {
            token_name: Self::find_token_name(self._token_index),
            token_index: self._token_index,
            line: self._line,
            col: self._col,
            reason: reason,
        }
    }

    #[inline]
    fn set_yytext(&mut self, value: usize) {
        self._yytext = value;
    }

    #[inline]
    fn get_yytext(&self) -> usize {
        self._yytext
    }

    #[inline]
    fn get_token_index(&self) -> usize {
        self._token_index
    }

    #[inline]
    fn begin(&mut self, initial_input: usize) {
        self._initial_input = initial_input;
    }

    fn get_token(&mut self) -> <{ class }>Result {
        if self._advanced {
            match self.next() {
                Ok(value) => {self._token_index = value;},
                Err(err) => {return Err(err);},
            };
            self._advanced = false;
        }
        Ok(self._token_index)
    }

    fn next(&mut self) -> <{ class }>Result {
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
                    /* 计算行列位置 */
                    if _och != u64::MAX {
                        if _ch == 0x0d {//\r
                            self._col = 0;
                            self._line += 1;
                        } else if _ch == 0x0a {//\n
                            if _och != 0x0d {//\r
                                self._col = 0;
                                self._line += 1;
                            }
                        } else {
                            self._col += 1;
                        }
                    }

                    _och = _ch;
                    _next_state = match self.trans(_cur_state, _ch) {
                        Ok(st) => { st },
                        Err(err) => { return Err(err); }
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
                        self._yytext = 0;//set yytext
                        self._old_start = self._start;
                        self._start = _last_final_position;
                        let _findex = self.trans_table[_last_final_state].final_index;
                        <{ actions }>
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

    fn trans(&self, cur_state: usize, ch: u64) -> <{ class }>Result {
        if ch < self.input_table[0].from || ch > self.input_table[self.input_table.len() - 1].to {
            return Err(self.new_lexer_error("input char out of valid range".to_string()));
        }
        if self.trans_table[cur_state].is_dead {
            return Ok(DEADSTATE);
        }
        let pub_input = Self::find(ch, &self.input_table);
        let inner_input = Self::find(pub_input, &self.trans_table[cur_state].trans_edge);
        return Ok(self.trans_table[cur_state].to_states[inner_input as usize])
    }

    pub fn lex_seq(source: &str) -> Result<Vec<(&'static str, Token, usize, usize, usize)>, <{ class }>Error> {//(token_name, token_index, yytext, star, end)
        let mut lexer = <{ class }>::new();
        lexer.set_source(source);
        let mut tokens = Vec::new();
        let mut token: usize = 0;
        match lexer.get_token() {
            Ok(value) => { token = value; },
            Err(err) => {return Err(err);},
        };
        while !Self::is_end_token(token) {
            tokens.push((Self::find_token_name(token), token, lexer.get_yytext(), lexer.start_index(), lexer.end_index()));
            lexer.advance();
            match lexer.get_token() {
                Ok(value) => { token = value; },
                Err(err) => {return Err(err);},
            };
        }
        Ok(tokens)
    }
}
]]></r>);
    }
}