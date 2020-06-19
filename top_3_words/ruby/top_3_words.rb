def top_3_words(text)
  text.scan(%r{\w+'?\w?}).
    each_with_object(Hash.new(0)) { |word, counter| counter[word.downcase] += 1 }.
    sort_by { |_, frequency| -frequency }.
    first(3).
    map(&:first)
end

def equals(x, y)
  if x == y
    puts "PASSED. #{x}"
  else
    puts "Failed: expected #{y}, got #{x}"
  end
end

equals(top_3_words("a a a  b  c c  d d d d  e e e e e"), ["e", "d", "a"])
equals(top_3_words("e e e e DDD ddd DdD: ddd ddd aa aA Aa, bb cc cC e e e"), ["e", "ddd", "aa"])
equals(top_3_words("  //wont won't won't "), ["won't", "wont"])
equals(top_3_words("  , e   .. "), ["e"])
equals(top_3_words("  ...  "), [])
equals(top_3_words("  '  "), [])
equals(top_3_words("  '''  "), [])
equals(top_3_words("""In a village of La Mancha, the name of which I have no desire to call to
mind, there lived not long since one of those gentlemen that keep a lance
in the lance-rack, an old buckler, a lean hack, and a greyhound for
coursing. An olla of rather more beef than mutton, a salad on most
nights, scraps on Saturdays, lentils on Fridays, and a pigeon or so extra
on Sundays, made away with three-quarters of his income."""), ["a", "of", "on"])
