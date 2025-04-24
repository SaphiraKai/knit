import gleeunit
import gleeunit/should

import knit

pub fn main() {
  gleeunit.main()
}

pub fn crop_test() {
  knit.from_string("1234567890abcdef")
  |> knit.crop_left(12)
  |> should.equal(knit.from_string("567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.crop_right(12)
  |> should.equal(knit.from_string("1234567890ab"))

  knit.from_string("1234567890abcdef")
  |> knit.crop_centre(12)
  |> should.equal(knit.from_string("34567890abcd"))

  knit.from_string("1234567890abcdef")
  |> knit.crop_left(16)
  |> should.equal(knit.from_string("1234567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.crop_centre(0)
  |> should.equal(knit.from_string(""))
}

pub fn pad_test() {
  knit.from_string("1234567890abcdef")
  |> knit.pad_left(24, "")
  |> should.equal(knit.from_string("        1234567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.pad_right(24, "")
  |> should.equal(knit.from_string("1234567890abcdef        "))

  knit.from_string("1234567890abcdef")
  |> knit.pad_centre(24, "")
  |> should.equal(knit.from_string("    1234567890abcdef    "))

  knit.from_string("1234567890abcdef")
  |> knit.pad_right(24, ".")
  |> should.equal(knit.from_string("1234567890abcdef........"))

  knit.from_string("1234567890abcdef")
  |> knit.pad_right(24, "-|")
  |> should.equal(knit.from_string("1234567890abcdef--------"))

  knit.from_string("1234567890abcdef")
  |> knit.pad_left(16, "")
  |> should.equal(knit.from_string("1234567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.pad_centre(0, "")
  |> should.equal(knit.from_string("1234567890abcdef"))
}

pub fn ellipsize_test() {
  knit.from_string("1234567890abcdef")
  |> knit.ellipsize(12, "")
  |> should.equal(knit.from_string("123456789..."))

  knit.from_string("1234567890abcdef")
  |> knit.ellipsize(12, "~")
  |> should.equal(knit.from_string("1234567890a~"))

  knit.from_string("1234567890abcdef")
  |> knit.ellipsize(2, "")
  |> should.equal(knit.from_string(".."))

  knit.from_string("1234567890abcdef")
  |> knit.ellipsize(0, "")
  |> should.equal(knit.from_string(""))
}

pub fn digit_separator_test() {
  knit.from_string("1234567890")
  |> knit.digit_separator(3, "")
  |> should.equal(knit.from_string("1,234,567,890"))

  knit.from_string("1234567.890")
  |> knit.digit_separator(3, "")
  |> should.equal(knit.from_string("1,234,567.890"))

  knit.from_string("-123456.7890")
  |> knit.digit_separator(3, "")
  |> should.equal(knit.from_string("-123,456.7890"))

  knit.from_string("123456.7890")
  |> knit.digit_separator(3, "")
  |> should.equal(knit.from_string("123,456.7890"))

  knit.from_string("1234567890")
  |> knit.digit_separator(2, "_")
  |> should.equal(knit.from_string("12_34_56_78_90"))
}

pub fn margin_test() {
  knit.from_string("1234567890abcdef")
  |> knit.margin_left(2, " ")
  |> should.equal(knit.from_string("  1234567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.margin_right(2, " ")
  |> should.equal(knit.from_string("1234567890abcdef  "))

  knit.from_string("1234567890abcdef")
  |> knit.margin_centre(2, " ")
  |> should.equal(knit.from_string(" 1234567890abcdef "))

  knit.from_string("1234567890abcdef")
  |> knit.margin_centre(0, " ")
  |> should.equal(knit.from_string("1234567890abcdef"))

  knit.from_string("1234567890abcdef")
  |> knit.margin_centre(0, "")
  |> should.equal(knit.from_string("1234567890abcdef"))
}

pub fn simple_wrap_test() {
  knit.from_string("1234567890abcdef")
  |> knit.simple_wrap(8)
  |> should.equal([knit.from_string("12345678"), knit.from_string("90abcdef")])

  knit.from_string("1234567890abcdef")
  |> knit.simple_wrap(12)
  |> should.equal([knit.from_string("1234567890ab"), knit.from_string("cdef")])
}

pub fn split_join_test() {
  knit.from_string("line 1\nline 2\nline 3")
  |> knit.split("\n")
  |> knit.join("\n")
  |> should.equal(knit.from_string("line 1\nline 2\nline 3"))

  knit.from_string("")
  |> knit.split("\n")
  |> knit.join("\n")
  |> should.equal(knit.from_string(""))
}
