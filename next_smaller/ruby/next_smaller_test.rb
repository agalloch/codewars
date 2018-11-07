# frozen_string_literal: true

require 'minitest/autorun'
require 'pp'
require 'pry'
require 'color_pound_spec_reporter'

Minitest::Reporters.use! [ColorPoundSpecReporter.new]

require './next_smaller'

class NextSmallerTest < Minitest::Test
  def test_next_smaller
    assert_equal next_smaller(907), 790
    assert_equal next_smaller(531), 513
    assert_equal next_smaller(2071), 2017
    assert_equal next_smaller(414), 144
    assert_equal next_smaller(123_456_798), 123_456_789
    assert_equal next_smaller(1_234_567_908), 1_234_567_890
  end

  def test_next_smaller_does_not_exist
    assert_equal next_smaller(135), -1
    assert_equal next_smaller(123_456_789), -1
  end
end
