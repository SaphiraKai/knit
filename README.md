# knit

[![Package Version](https://img.shields.io/hexpm/v/knit)](https://hex.pm/packages/knit)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/knit/)

```sh
gleam add knit@1
```
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
