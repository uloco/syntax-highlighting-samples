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


let syntax = ps.find_syntax_by_extension("rs").unwrap();
let mut h = HighlightLines::new(syntax, &ts.themes["base16-ocean.dark"]);
let s = "pub struct Wow { hi: u64 }\nfn blah() -> u64 {}";
for line in LinesWithEndings::from(s) {
    let ranges: Vec<(Style, &str)> = h.highlight_line(line, &ps).unwrap();
    let escaped = as_24_bit_terminal_escaped(&ranges[..], true);
    print!("{}", escaped);

}

extern crate piston_window;
extern crate rand;

mod snake;
mod game;
mod drawing;

use piston_window::*;
use piston_window::types::Color;

use game::Game;
use drawing::to_gui_coord_u32;

const BACK_COLOR: Color = [0.204, 0.286, 0.369, 1.0];

fn abc(nu: Game) {

    nu + 1
}

fn main() {
    let (width, height) = (20, 20);

    // Prepare window settings
    let mut window_settings = WindowSettings::new("Rust Snake",
    [to_gui_coord_u32(width), to_gui_coord_u32(height)]).exit_on_esc(true);

    // Fix vsync extension error for linux
    window_settings.set_vsync(true); 

    // Create a window
    let mut window: PistonWindow = window_settings.build().unwrap();

    // Create a snake
    let mut game = Game::new(width, height);

    // Event loop
    while let Some(event) = window.next() {

        // Catch the events of the keyboard
        if let Some(Button::Keyboard(key)) = event.press_args() {
            game.key_pressed(key);
        }

        // Draw all of them
        window.draw_2d(&event, |c, g, _| {
            clear(BACK_COLOR, g);
            game.draw(&c, g);
        });

        // Update the state of the game
        event.update(|arg| {
            game.update(arg.dt);
        });
    }
}
