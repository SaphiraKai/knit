# knit
## *Knit your strings!*
[![Package Version](https://img.shields.io/hexpm/v/knit_string)](https://hex.pm/packages/knit_string)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/knit_string/)
---

`knit` is a Gleam library for formatting strings.
It is a replacement for my older `glormat` library, which had some fundamental issues in its design.[^1]

`knit` doesn't try to replace the string concatenation operator `<>`, it focuses on formatting values and leaves concatenation to the operator that was designed for it!

## Usage
Rather than writing full formatters inline- which takes up lots of space- `knit` returns composed formatters that can be bound to short variable names (e.g. `pad`, `crop`, `align`, `fmt`, etc.), which are then called inline with the `<>` operator to paste the resulting `String`s together.

Formatters are composable, and can be chained together to create more complex formatters. It's recommended to use the `use` keyword for this:
```gleam
import gleam/io
import gleam/list
import gleam/string

import knit

pub fn main() {
  let header = {
    let title_case = {
      use string <- knit.with
      string.split(string, " ") |> list.map(string.capitalise) |> string.join(" ")
    }

    use yarn <- knit.new
    title_case(yarn)
    |> knit.margin_centre(2, " ")
    |> knit.pad_centre(48, "#")
    |> knit.margin_right(1, "\n")
  }

  let body_line = {
    use yarn <- knit.new
    yarn
    |> knit.pad_left(40, " ")
    |> knit.margin_centre(6, " ")
    |> knit.margin_centre(2, "|")
    |> knit.margin_right(1, "\n")
  }

  let value = knit.new(knit.pad_right(_, 16, " "))

  io.println(
    header("gleam sponsorship receipt")
    <> body_line("NAME: " <> value("Jane Doe"))
    <> body_line("")
    <> body_line("SUBTOTAL: " <> value("$16"))
    <> body_line("EST. TAX: " <> value("1.50 hugs"))
    <> body_line("TOTAL: " <> value("$16 + 1.50 hugs")),
  )
}
```
```text
########## Gleam Sponsorship Receipt ###########
|                     NAME: Jane Doe           |
|                                              |
|                 SUBTOTAL: $16                |
|                 EST. TAX: 1.50 hugs          |
|                    TOTAL: $16 + 1.50 hugs    |

```

Further documentation can be found at <https://hexdocs.pm/knit>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

> [^1]: My older library `glormat` attempted to mimic the string formatting API style found in other languages such as Python or Rust- but without compile-time evaluation or some other kind of metaprogramming, the code had to be messy in order to work and didn't feel great to use. It also didn't really take advantage of Gleam's useful features.
