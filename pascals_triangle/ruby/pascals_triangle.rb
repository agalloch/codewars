def pascals_triangle(n)
  n.pred.times.each_with_object [1] do |_, row|
    row << [1, *Array(row.last).each_cons(2).map(&:sum), 1]
  end.flatten
end

p pascals_triangle(4) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1]
p pascals_triangle(6) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1, 1, 4, 6, 4, 1, 1, 5, 10, 10, 5, 1]
p pascals_triangle(10) == [1, 1, 1, 1, 2, 1, 1, 3, 3, 1, 1, 4, 6, 4, 1, 1, 5, 10, 10, 5, 1, 1, 6, 15, 20, 15, 6, 1, 1, 7, 21, 35, 35, 21, 7, 1, 1, 8, 28, 56, 70, 56, 28, 8, 1, 1, 9, 36, 84, 126, 126, 84, 36, 9, 1]