//// Start knitting with the [`new`](#new)/[`from`](#from) functions!
////
//// > For complexity reasons, formatters are not aware of linebreaks! See [`split`](#split) for an example on how to handle multiline `String`s.
////
//// > Except where otherwise noted; for formatters that take a `width`, the total length of the resulting `String` will never exceed `width`.

import gleam/int
import gleam/list
import gleam/result
import gleam/string

/// Internal type for processing `String`s more efficiently.
pub opaque type Yarn {
  Yarn(string: String, length: Int)
}

/// Drop characters from the left side of a `String` if it exceeds `width`.
///
/// - If `width` is less than 0, it will be clamped to 0.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.crop_left(_, 5))("hello world") // "hello"
/// ```
pub fn crop_left(this: Yarn, to width: Int) -> Yarn {
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len <= width -> this
    len -> Yarn(string.slice(str, len - width, width), width)
  }
}

/// Drop characters from the right side of a `String` if it exceeds `width`.
///
/// - If `width` is less than 0, it will be clamped to 0.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.crop_right(_, 5))("hello world") // "world"
/// ```
pub fn crop_right(this: Yarn, to width: Int) -> Yarn {
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len <= width -> this
    _ -> Yarn(string.slice(str, 0, width), width)
  }
}

/// Drop characters equally from both sides of a `String` if it exceeds `width`.
///
/// - If `width` is less than 0, it will be clamped to 0.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.crop_centre(_, 5))("hello world") // "lo wo"
/// ```
pub fn crop_centre(this: Yarn, to width: Int) -> Yarn {
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len <= width -> this
    len -> Yarn(string.slice(str, { len - width } / 2, width), width)
  }
}

/// Pad the left side of a `String` with `fill` if it is less than `width`.
///
/// - The resulting `String` will be allowed to exceed `width`.
/// - If `width` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.pad_left(_, 15, " "))("hello world") // "    hello world"
/// ```
pub fn pad_left(this: Yarn, to width: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len > width -> this
    _ -> Yarn(string.pad_start(str, width, fill), width)
  }
}

/// Pad the right side of a `String` with `fill` if it is less than `width`.
///
/// - The resulting `String` will be allowed to exceed `width`.
/// - If `width` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.pad_right(_, 15, " "))("hello world") // "hello world    "
/// ```
pub fn pad_right(this: Yarn, to width: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len > width -> this
    _ -> Yarn(string.pad_end(str, width, fill), width)
  }
}

/// Pad both sides of a `String` with `fill` if it is less than `width`.
///
/// - The resulting `String` will be allowed to exceed `width`.
/// - If `width` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.pad_centre(_, 15, " "))("hello world") // "  hello world  "
/// ```
pub fn pad_centre(this: Yarn, to width: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len {
    len if len > width -> this
    len -> {
      let padding = width - len
      let pfx = string.repeat(fill, padding / 2)
      let sfx = pfx <> string.repeat(fill, padding % 2)

      Yarn(pfx <> str <> sfx, width)
    }
  }
}

/// Ellipsize the right side of a `String` with `ellipses` if the total length exceeds `width`.
///
/// - If `width` is less than 0, it will be clamped to 0.
/// - If `ellipses` is `""`, it will default to `"..."`.
/// - `ellipses` is truncated to `width`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.ellipsize(_, 10, "..."))("hello world") // "hello w..."
/// ```
/// ```gleam
/// knit.new(knit.ellipsize(_, 11, "..."))("hello world") // "hello world"
/// ```
pub fn ellipsize(this: Yarn, to width: Int, with ellipses: String) -> Yarn {
  let Yarn(str, len) = this
  let width = int.max(width, 0)
  let ellipses =
    case ellipses {
      "" -> "..."
      a -> a
    }
    |> string.slice(0, width)
  let content_width = width - string.length(ellipses)

  case len {
    len if len <= content_width -> this
    _ -> Yarn(string.slice(str, 0, content_width) <> ellipses, width)
  }
}

/// Add a `separator` every `interval` integer digits in a `String` representing a number.
///
/// - If `interval` is less than 1, it will default to 3.
/// - `separator` is truncated to the first character.
/// - If `separator` is `""`, it will default to `","`.
/// - This function does not check that what it's processing _actually_ represents a number; this may lead to amusing behavior if used on other `String`s.
///
/// ## Examples:
/// ```gleam
/// knit.from(int.to_string, knit.digit_separator(_, 3, ","))(1_000_000) // "1,000,000"
/// ```
/// ```gleam
/// knit.from(float.to_string, knit.digit_separator(_, 3, "_"))(1_000.0001) // "1_000.0001"
/// ```
/// ```gleam
/// knit.from(int.to_string, knit.digit_separator(_, 3, "."))(-100_001) // "-100.001"
/// ```
pub fn digit_separator(
  this: Yarn,
  every interval: Int,
  with separator: String,
) -> Yarn {
  let Yarn(str, len) = this
  let separator = string.first(separator) |> result.unwrap(",")
  let interval = case interval {
    a if a < 1 -> 3
    a -> a
  }

  let #(sign, str) = case str {
    "-" <> rest -> #("-", rest)
    a -> #("", a)
  }

  let #(integer, decimal) = case string.split_once(str, ".") {
    Ok(#(i, d)) -> #(i, "." <> d)
    _ -> #(str, "")
  }

  let chunks =
    string.reverse(integer)
    |> string.to_graphemes
    |> list.sized_chunk(interval)
  let separator_count = list.length(chunks) - 1
  let integer =
    chunks
    |> list.map(string.concat)
    |> string.join(separator)
    |> string.reverse

  Yarn(sign <> integer <> decimal, len + separator_count)
}

/// Create a new formatter that accepts `String`s.
///
/// ## Examples:
/// ```gleam
/// let pad = knit.new(knit.pad_centre(_, 15, " "))
/// pad("hello world") // "  hello world  "
/// ```
/// ```gleam
/// let fmt = {
///   use yarn <- knit.new
///   yarn |> knit.crop_centre(9) |> knit.pad_centre(9, " ")
/// }
///
/// fmt("hello world") // "ello worl"
/// fmt("hello") // "  hello  "
/// ```
pub fn new(formatter: fn(Yarn) -> Yarn) -> fn(String) -> String {
  fn(str) { formatter(Yarn(str, string.length(str))).string }
}

/// Create a new formatter that accepts any type you can convert to a `String`.
///
/// ## Examples:
/// ```gleam
/// let fmt = knit.from(int.to_string, knit.digit_separator(_, 3, " "))
/// fmt(3_141_592) // "3 141 592"
/// ```
/// ```gleam
/// let normalise = {
///   use yarn <- knit.from(fn(a) { a |> float.to_precision(2) |> float.to_string })
///   yarn |> knit.pad_right(8, "0")
/// }
///
/// normalise(3.1415926) // "3.140000"
/// normalise(1000.1) // "1000.100"
/// ```
pub fn from(
  from: fn(a) -> String,
  formatter: fn(Yarn) -> Yarn,
) -> fn(a) -> String {
  fn(a) {
    let str = from(a)
    formatter(Yarn(str, string.length(str))).string
  }
}

/// Convert any `fn(String) -> String` into a composable formatter.
///
/// - The formatter returned by this function will always call `string.length`, take care when calling repeatedly on large inputs.
///
/// ## Examples:
/// ```gleam
/// let header = {
///   use yarn <- knit.new
///   yarn |> knit.with(string.uppercase) |> knit.pad_centre(32, "-")
/// }
///
/// echo header("section header") // "---------SECTION HEADER---------"
/// ```
/// ```gleam
/// let header = {
///   let title_case = {
///     use string <- knit.with
///     string.split(string, " ") |> list.map(string.capitalise) |> string.join(" ")
///   }
///   use yarn <- knit.new
///   title_case(yarn) |> knit.pad_centre(32, " ")
/// }
///
/// echo header("section 2: electric boogaloo") // "  Section 2: Electric Boogaloo  "
/// ```
pub fn with(this: fn(String) -> String) -> fn(Yarn) -> Yarn {
  fn(yarn: Yarn) {
    let str = this(yarn.string)
    Yarn(str, string.length(str))
  }
}

/// Convert any `fn(String, a) -> String` into a composable formatter.
///
/// - The formatter returned by this function will always call `string.length`, take care when calling repeatedly on large inputs.
/// - If you need to pass more than one argument, try using a tuple!
///
/// ## Examples:
/// ```gleam
/// // todo
/// ```
pub fn with_arg(this: fn(String, a) -> String) -> fn(Yarn, a) -> Yarn {
  fn(yarn: Yarn, a) {
    let str = this(yarn.string, a)
    Yarn(str, string.length(str))
  }
}

/// Pad the left side of a `String` with `fill`, `amount` times.
///
/// - If `amount` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.margin_left(_, 4, " "))("hello world") // "    hello world"
/// ```
pub fn margin_left(this: Yarn, by amount: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let amount = int.max(amount, 0)

  Yarn(string.repeat(fill, amount) <> str, len + amount)
}

/// Pad the right side of a `String` with `fill`, `amount` times.
///
/// - If `amount` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.margin_right(_, 4, " "))("hello world") // "hello world    "
/// ```
pub fn margin_right(this: Yarn, by amount: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let amount = int.max(amount, 0)

  Yarn(str <> string.repeat(fill, amount), len + amount)
}

/// Pad both sides of a `String` with `fill`, adding `amount` characters total.
///
/// - If `amount` is less than 0, it will be clamped to 0.
/// - `fill` is truncated to the first character.
/// - If `fill` is `""`, it will default to `" "`.
///
/// ## Examples:
/// ```gleam
/// knit.new(knit.margin_centre(_, 4, " "))("hello world") // "  hello world  "
/// ```
pub fn margin_centre(this: Yarn, by amount: Int, with fill: String) -> Yarn {
  let fill = string.first(fill) |> result.unwrap(" ")
  let Yarn(str, len) = this
  let amount = int.max(amount, 0)
  let pfx = string.repeat(fill, amount / 2)
  let sfx = pfx <> string.repeat(fill, amount % 2)

  Yarn(pfx <> str <> sfx, len + amount)
}

/// Simply wrap a `String` onto multiple lines at `width`.
///
/// - This function is very simplistic and does not wrap at word boundaries or hyphenate. If you're looking for something fancier, consider the [`string_width`](https://hex.pm/packages/string_width) package!
///
/// ## Examples:
/// ```gleam
/// knit.new(fn(yarn) { knit.simple_wrap(yarn, 16) |> knit.from_lines })(
///   "this is a long sentence that maybe doesn't look so great",
/// )
/// ```
/// ```text
/// this is a long s
/// entence that may
/// be doesn't look
/// so great
/// ```
pub fn simple_wrap(this: Yarn, to width: Int) -> List(Yarn) {
  let Yarn(str, len) = this
  let width = int.max(width, 0)

  case len > width {
    False -> list.wrap(this)
    True ->
      string.to_graphemes(str)
      |> list.sized_chunk(width)
      |> list.map(fn(a) { Yarn(string.concat(a), list.length(a)) })
  }
}

/// Split a `String` by `separator`.
///
/// This function is useful for formatting multiline `String`s correctly!
///
/// - `separator` is truncated to the first character.
/// - If `separator` is `""`, it will default to `"\n"`.
///
/// ## Examples:
/// ```gleam
/// let fmt = {
///   use yarn <- knit.new
///   yarn
///   |> knit.split("\n")
///   |> list.map(fn(yarn) {
///     knit.pad_centre(yarn, 14, " ") |> knit.margin_centre(2, "|")
///   })
///   |> knit.join("\n")
/// }
/// 
/// fmt("line 1\nline 2\nline 3")
/// ```
/// ```text
/// |    line 1    |
/// |    line 2    |
/// |    line 3    |
/// ```
pub fn split(this: Yarn, by separator: String) -> List(Yarn) {
  let separator = string.first(separator) |> result.unwrap("\n")
  let Yarn(str, _) = this

  string.split(str, separator) |> list.map(fn(a) { Yarn(a, string.length(a)) })
}

/// Join `String`s by `separator`.
///
/// - `separator` is truncated to the first character.
/// - If `separator` is `""`, it will default to `"\n"`.
///
/// ## Examples:
/// - See [`split`](#split)
pub fn join(this: List(Yarn), with separator: String) -> Yarn {
  let separator = string.first(separator) |> result.unwrap("\n")
  let Yarn(str, len) =
    list.fold(this, Yarn("", 0), fn(a, b) {
      Yarn(a.string <> separator <> b.string, a.length + b.length + 1)
    })

  Yarn(string.slice(str, 1, len - 1), len - 1)
}

/// Convert a `String` into a `Yarn`.
///
/// - This requires a call to `string.length`.
pub fn from_string(this: String) -> Yarn {
  Yarn(this, string.length(this))
}

/// Convert a `String` into a `Yarn`.
pub fn to_string(this: Yarn) -> String {
  this.string
}

/// Get the length of a `Yarn`.
///
/// - This is a "free" operation, as the length is already tracked.
pub fn length(this: Yarn) -> Int {
  this.length
}
