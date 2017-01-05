package org.lala.compilercompile.utils
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
		
		private static const Src:String = String(<r><![CDATA[extern crate rustc_serialize;

use self::rustc_serialize::json::Json;

use lexer::RegexLexer;
use lexer::RegexLexerError;

<{ usercode }>

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
}

impl Parser {
    pub fn new() -> Parser {
        Parser { prod_list: vec![<{ tables }>]
               , lookup_table: vec![<{ lookup_table }>] }
    }

    fn lookup(&self, token: Token, state: State) -> Action {
        let input_length: usize = <{ input_length }>;
		let state_length: usize = <{ state_length }>;
		if token >= input_length || state >= state_length {
			return Action::Error;
		}
		return self.lookup_table[token * state_length + state].clone();
    }

    pub fn parse(&self, lexer: &mut RegexLexer) -> Result<Json, RegexLexerError> {
		<{ initial }>
        let mut state_stack: Vec<State> = vec![0];
        let mut output_stack: Vec<Json> = Vec::new();

        loop {
            let token = match lexer.get_token() {
                Ok(token) => token,
                Err(err) => return Err(err),
            };
            let state = state_stack[state_stack.len() - 1];
            let action = self.lookup(token, state);
            //println!("{:?}", ("cur_state", state, "token", RegexLexer::find_token_name(token), token, lexer.get_yytext(), "action", action));
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
                        <{ actions }>
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
}
]]></r>);
    }
}