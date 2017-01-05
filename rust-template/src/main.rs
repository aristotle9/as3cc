extern crate rustc_serialize;

use rustc_serialize::json::as_pretty_json;
use std::env;

mod parser;
mod lexer;

fn main() {
    let ptn = match env::args().nth(1) {
        Some(argv) => argv,
        _ => "(a|b)*abc\\f\\b{1}".to_string()
    };
    let seq = lexer::RegexLexer::lex_seq(&ptn);
    println!("{:?}", seq);
    let mut l = lexer::RegexLexer::new();
    l.set_source(&ptn);
    let mut p = parser::Parser::new();
    let r = p.parse(&mut l).unwrap();
    println!("{}", as_pretty_json(&r));
}