use syntect::easy::HighlightLines;
use syntect::parsing::SyntaxSet;
use syntect::highlighting::{ThemeSet, Style};
use syntect::util::{as_24_bit_terminal_escaped, LinesWithEndings};

fn print_square(num: f64) {
  let result = f64::powf(num, 2.0);
  println!("The square of {:.2} is {:.2}.", num, result);
}

// Load these once at the start of your program
let ps = SyntaxSet::load_defaults_newlines();
let ts = ThemeSet::load_defaults();

fn jockl(a:int) {

}

let syntax = ps.find_syntax_by_extension("rs").unwrap();
let mut h = HighlightLines::new(syntax, &ts.themes["base16-ocean.dark"]);
let s = "pub struct Wow { hi: u64 }\nfn blah() -> u64 {}";
for line in LinesWithEndings::from(s) {
    let ranges: Vec<(Style, &str)> = h.highlight_line(line, &ps).unwrap();
    let escaped = as_24_bit_terminal_escaped(&ranges[..], true);
    print!("{}", escaped);
}
