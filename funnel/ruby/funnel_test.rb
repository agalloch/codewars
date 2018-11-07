# frozen_string_literal: true

require 'minitest/autorun'
require 'pp'
require 'pry'
require 'color_pound_spec_reporter'

Minitest::Reporters.use! [ColorPoundSpecReporter.new]

require_relative 'funnel'

class FunnelTest < Minitest::Test
  def test_empty
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\   /
    \\ /
    ).strip

    assert_equal expected_value, funnel.to_s
  end

  def test_fill_one
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\   /
    \\A/
    ).strip

    funnel.fill 'A'

    assert_equal expected_value, funnel.to_s
  end

  def test_fill_one_by_one
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\2 3/
    \\1/
    ).strip

    funnel.fill 1
    funnel.fill 2
    funnel.fill 3

    actual_value = funnel.to_s

    assert_equal expected_value, actual_value
  end

  def test_fill_at_once
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\7    /
   \\5 6/
    \\4/
    ).strip

    funnel.fill 4, 5, 6, 7

    actual_value = funnel.to_s

    assert_equal expected_value, actual_value
  end

  def test_fill_max_capacity
    funnel = Funnel.new
    expected_value = %(
\\11 12 13 14 15/
 \\7 8 9 10/
  \\4 5 6/
   \\2 3/
    \\1/
    ).strip

    funnel.fill(*(1..20))

    actual_value = funnel.to_s

    assert_equal expected_value, actual_value
  end

  def test_drip_empty
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\   /
    \\ /
    ).strip

    assert_nil funnel.drip
    assert_equal expected_value, funnel.to_s
  end

  def test_drip_last_element
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\   /
    \\ /
    ).strip

    funnel.fill 'b'

    assert_equal 'b', funnel.drip
    assert_equal expected_value, funnel.to_s
  end

  def test_drip_left_element
    funnel = Funnel.new
    expected_value = %(
\\         /
 \\       /
  \\     /
   \\  3/
    \\2/
    ).strip

    funnel.fill 1, 2, 3

    assert_equal 1, funnel.drip
    assert_equal expected_value, funnel.to_s
  end

  def test_drip_group_3
    funnel = Funnel.new
    funnel.fill 12, 11, 15
    expected_value = [11, 15]

    assert_equal 12, funnel.drip
    assert_equal expected_value, funnel.to_a
  end

  def test_drip_group_6
    funnel = Funnel.new
    funnel.fill 14, 7, 13, 11, 12, 15

    assert_equal 14, funnel.drip
    assert_equal 7, funnel.drip
    assert_equal 13, funnel.drip
    assert_equal 12, funnel.drip
    assert_equal 11, funnel.drip
    assert_equal 15, funnel.drip

    assert_equal [], funnel.to_a
  end

  def test_drip_group_15
    funnel = Funnel.new
    funnel.fill(*(1..15))
    expected_value = [
      2, 4, 3, 7, 5, 6, 11, 8, 9, 10, 12, 13, 14, 15
    ]

    assert_equal 1, funnel.drip
    assert_equal expected_value, funnel.to_a
  end

  def test_special_kata_case
    funnel = Funnel.new
    funnel.fill 9, 6, 6, 2, 1, 6, 9, 2, 8, 1, 0, 0, 1, 9, 9

    start_funnel = %(
\\0 0 1 9 9/
 \\9 2 8 1/
  \\2 1 6/
   \\6 6/
    \\9/
    ).strip

    assert_equal start_funnel, funnel.to_s

    dripped_once = %(
\\  0 1 9 9/
 \\0 2 8 1/
  \\9 1 6/
   \\2 6/
    \\6/
    ).strip

    assert_equal 9, funnel.drip
    assert_equal dripped_once, funnel.to_s,
      'First drop'

    dripped_twice = %(
\\    1 9 9/
 \\0 0 8 1/
  \\9 2 6/
   \\2 1/
    \\6/
    ).strip

    assert_equal 6, funnel.drip
    assert_equal dripped_twice, funnel.to_s,
      'Second drop'

    dripped_thrice = %(
\\      9 9/
 \\0 0 1 1/
  \\9 2 8/
   \\2 6/
    \\1/
    ).strip

    assert_equal 6, funnel.drip
    assert_equal dripped_thrice, funnel.to_s,
      'Third drop'

    dripped_fourth_time = %(
\\        9/
 \\0 0 1 9/
  \\9 2 1/
   \\2 8/
    \\6/
    ).strip

    assert_equal 1, funnel.drip
    assert_equal dripped_fourth_time, funnel.to_s,
      'Fourth drop'

    funnel.fill 7, 1, 5

    refilled = %(
\\7 1 5   9/
 \\0 0 1 9/
  \\9 2 1/
   \\2 8/
    \\6/
    ).strip

    assert_equal refilled, funnel.to_s,
      "Refill didn't work correct"

    dripped_fifth_time = %(
\\  1 5   9/
 \\7 0 1 9/
  \\0 2 1/
   \\9 8/
    \\2/
    ).strip

    assert_equal 6, funnel.drip
    assert_equal dripped_fifth_time, funnel.to_s,
      'Fifth drop (of refilled)'

    dripped_sixth_time = %(
\\    5   9/
 \\7 1 1 9/
  \\0 0 1/
   \\9 2/
    \\8/
    ).strip

    assert_equal 2, funnel.drip
    assert_equal dripped_sixth_time, funnel.to_s,
      'Sixth and final drop'
  end
end
