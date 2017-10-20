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
\\           /
 \\         /
  \\       /
   \\     /
    \\   /
    ).strip

    assert_equal expected_value, funnel.to_s
  end

  def test_fill_one
    funnel = Funnel.new
    expected_value = %(
\\           /
 \\         /
  \\       /
   \\     /
    \\ A /
    ).strip

    funnel.fill 'A'

    assert_equal expected_value, funnel.to_s
  end

  def test_fill_one_by_one
    funnel = Funnel.new
    expected_value = %(
\\           /
 \\         /
  \\       /
   \\ 2 3 /
    \\ 1 /
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
\\           /
 \\         /
  \\ 7     /
   \\ 5 6 /
    \\ 4 /
    ).strip

    funnel.fill 4, 5, 6, 7

    actual_value = funnel.to_s

    assert_equal expected_value, actual_value
  end

  def test_fill_max_capacity
    funnel = Funnel.new
    expected_value = %(
\\ 11 12 13 14 15 /
 \\ 7 8 9 10 /
  \\ 4 5 6 /
   \\ 2 3 /
    \\ 1 /
    ).strip

    funnel.fill(*(1..20))

    actual_value = funnel.to_s

    assert_equal expected_value, actual_value
  end

  def test_drip_empty
    funnel = Funnel.new
    expected_value = %(
\\           /
 \\         /
  \\       /
   \\     /
    \\   /
    ).strip

    assert_nil funnel.drip
    assert_equal expected_value, funnel.to_s
  end

  def test_drip_last_element
    funnel = Funnel.new
    expected_value = %(
\\           /
 \\         /
  \\       /
   \\     /
    \\   /
    ).strip

    funnel.fill 'b'

    assert_equal 'b', funnel.drip
    assert_equal expected_value, funnel.to_s
  end
end
