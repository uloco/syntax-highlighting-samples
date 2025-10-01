/* This is a comment */

module ModuleName = {
  type t = {key: int};
  type tree('a) =
    | Node(tree('a))
    | Leaf;

  type poly = [
    | `Up
    | `Down
    | `Left
    | `Right
  ];

  let add = (x, y) => x + y;
  let myList = [1.0, 2.0, 3.];
  let array = [|1, 2, 3|];
  let myOption = Some(33);
  let choice = x =>
    switch (myOption) {
    | None => "nok"
    | Some(value) => "ok"
    };

  let constant = "My constant";
  let numericConstant = 123;
};

let value = "wrapper";
React.createElement(
  <div className=value> <Button> {React.string("ok")} </Button> </div>,
);
