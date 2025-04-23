# knit
## *Knit your strings!*
[![Package Version](https://img.shields.io/hexpm/v/knit)](https://hex.pm/packages/knit)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/knit/)
---

`knit` is a Gleam library for formatting strings.
It is a replacement for my older `glormat` library, which had some fundamental issues in its design.[^1]

`knit` doesn't try to replace the string concatenation operator `<>`, it focuses on formatting values and leaves concatenation to the operator that was designed for it!

## Usage
Rather than writing full formatters inline- which takes up lots of space- `knit` returns composed formatters that can be bound to short variable names (e.g. `pad`, `crop`, `align`, `fmt`, etc.), which are then called inline with the `<>` operator to paste the resulting `String`s together.

Formatters are composable, and can be chained together to create more complex formatters. It's recommended to use the `use` keyword for this:
```gleam
import gleam/io
import gleam/string
import knit

pub fn main() {
  let expression = "260 * 267"
  let result = 69_420
  let width = string.length("Expression")

  let left = knit.new(knit.pad_left(_, width, " "))
  let right = knit.from(int.to_string, knit.digit_separator(_, 3, " "))

  io.println(left("Expression") <> " | " <> expression)
  io.println(left("Result") <> " | " <> right(result))
}
```
```text
Expression | 260 * 267
    Result | 69 420
```

Further documentation can be found at <https://hexdocs.pm/knit>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

> [^1]: My older library `glormat` attempted to mimic the string formatting API style found in other languages such as Python or Rust- but without compile-time evaluation or some other kind of metaprogramming, the code had to be messy in order to work and didn't feel great to use. It also didn't really take advantage of Gleam's useful features.
