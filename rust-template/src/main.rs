extern crate rustc_serialize;

use rustc_serialize::json::as_pretty_json;
use std::env;

mod parser;
mod lexer;

fn main() {

    let ptn = match env::args().nth(1) {
        Some(argv) => argv,
        _ => "(a|b)*abc\\f\\b{1}".to_string(),
    };

    let seq = lexer::RegexLexer::lex_seq(&ptn);
    println!("{:?}", seq);

    let r = parser::Parser::parse_str(&ptn);
    match r {
        Ok(json_obj) => println!("{}", as_pretty_json(&json_obj)),
        Err(err) => println!("{:?}", err),
    }
}
