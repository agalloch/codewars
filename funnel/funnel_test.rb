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

    element = funnel.drip

    assert_equal 1, element
    assert_equal expected_value, funnel.to_a
  end
end
