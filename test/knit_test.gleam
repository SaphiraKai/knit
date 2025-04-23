import gleeunit
import gleeunit/should

import knit

pub fn main() {
  gleeunit.main()
}

pub fn crop_test() {
  knit.new(knit.crop_left(_, 12))("1234567890abcdef")
  |> should.equal("567890abcdef")

  knit.new(knit.crop_right(_, 12))("1234567890abcdef")
  |> should.equal("1234567890ab")

  knit.new(knit.crop_centre(_, 12))("1234567890abcdef")
  |> should.equal("34567890abcd")

  knit.new(knit.crop_left(_, 16))("1234567890abcdef")
  |> should.equal("1234567890abcdef")
}

pub fn pad_test() {
  knit.new(knit.pad_left(_, 24, ""))("1234567890abcdef")
  |> should.equal("        1234567890abcdef")

  knit.new(knit.pad_right(_, 24, ""))("1234567890abcdef")
  |> should.equal("1234567890abcdef        ")

  knit.new(knit.pad_centre(_, 24, ""))("1234567890abcdef")
  |> should.equal("    1234567890abcdef    ")

  knit.new(knit.pad_right(_, 24, "."))("1234567890abcdef")
  |> should.equal("1234567890abcdef........")

  knit.new(knit.pad_right(_, 24, "-|"))("1234567890abcdef")
  |> should.equal("1234567890abcdef--------")

  knit.new(knit.pad_left(_, 16, ""))("1234567890abcdef")
  |> should.equal("1234567890abcdef")
}

pub fn ellipsize_test() {
  knit.new(knit.ellipsize(_, 12, ""))("1234567890abcdef")
  |> should.equal("123456789...")

  knit.new(knit.ellipsize(_, 12, "~"))("1234567890abcdef")
  |> should.equal("1234567890a~")

  knit.new(knit.ellipsize(_, 2, ""))("1234567890abcdef")
  |> should.equal("..")
}

pub fn digit_separator_test() {
  knit.new(knit.digit_separator(_, 3, ""))("1234567890")
  |> should.equal("1,234,567,890")

  knit.new(knit.digit_separator(_, 3, ""))("1234567.890")
  |> should.equal("1,234,567.890")

  knit.new(knit.digit_separator(_, 3, ""))("-123456.7890")
  |> should.equal("-123,456.7890")

  knit.new(knit.digit_separator(_, -1, ""))("123456.7890")
  |> should.equal("123,456.7890")

  knit.new(knit.digit_separator(_, 2, "_"))("1234567890")
  |> should.equal("12_34_56_78_90")
}
