def pascals_triangle(n)
  n.times.reduce({[1], [1]}) do |row, row_ix|
    next row if row_ix == 0

    triangle, previous_row = row
    this_row = [1] + previous_row.each_cons(2).map(&.sum).to_a + [1]

    {this_row.each_with_object(triangle) { |num, acc| acc << num }, this_row}
  end.first
end

def pascals_triangle(n)
  (1...n).reduce([1]) do |a, b|
    a + (0..b).map { |e| a[-b + e] + (e > 0 && b - e > 0 ? (a[-b + e - 1]? || 0) : 0) }
  end
end

p [1].each_cons(2).map { |(x, y)| x + y }.to_a
p pascals_triangle(4) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1]
p pascals_triangle(6) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1, 1, 4, 6, 4, 1, 1, 5, 10, 10, 5, 1]
p pascals_triangle(10) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1, 1, 4, 6, 4, 1, 1, 5, 10, 10, 5, 1, 1, 6, 15, 20, 15, 6, 1, 1, 7, 21, 35, 35, 21, 7, 1, 1, 8, 28, 56, 70, 56, 28, 8, 1, 1, 9, 36, 84, 126, 126, 84, 36, 9, 1]
