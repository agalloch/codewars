class Funnel
  CAPACITY = 15

  attr_reader :funnel

  def initialize
    @funnel = []
  end

  def fill(*numbers)
    funnel.concat numbers.first CAPACITY
  end

  def to_s
    rows.strip
  end

  def drip
    funnel.shift
  end

  private

  def rows
    ze_funnel = funnel.dup

    5.times.reverse_each.each_with_index.map do |row, index|
      prepad row, nth_row(ze_funnel, index.succ)
    end.reverse.join "\n"
  end

  def nth_row(elements, slots)
    string_row elements.shift(slots), slots
  end

  def string_row(elements, n)
    "\\ #{row(elements, n)} /"
  end

  def row(elements, slots)
    ([' '] * slots)
      .zip(elements)
      .map { |pad, el| el ? el : pad }
      .join ' '
  end

  def prepad(n, string)
    "#{' ' * n}#{string}"
  end
end
