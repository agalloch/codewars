class Funnel
  CAPACITY = 15

  attr_reader :funnel

  def initialize
    @funnel = []
    # @tree = build_tree funnel

    top = Group.new(nil, 5)
    fourth = Group.new(top, 4)
    third = Group.new(fourth, 3)
    second = Group.new(third, 2)
    bottom = Group.new(second, 1)

    @groups = [
      top,
      fourth,
      third,
      second,
      bottom
    ].reverse
  end

  def fill(*numbers)
    funnel.concat numbers.first CAPACITY
    # @tree = build_tree funnel

    new_content = numbers.dup
    while new_content.any?
      @groups.each do |g|
        while new_content.first and !g.full?
          g.fill new_content.shift
        end
      end
    end
  end

  def to_s
    rows.strip
  end

  def drip
    funnel.shift
    @groups.first.drip
  end

  def to_a
    @groups.each_with_object([]) do |g, result|
      result.concat g.to_a
    end
  end

  private

  attr_reader :tree

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

  class Group
    def initialize(top_group, capacity)
      @top_group = top_group
      @capacity = capacity
      @group = []
    end

    def fill(el)
      return if full?

      group << el
    end

    def drip
      binding.pry if top_group&.to_a.size == 2
      return group.shift unless top_group&.to_a.any?

      drip_index = group.each_with_index.map do |el, ix|
        [top_group.to_a[ix..ix.succ].count { |el| !el.nil? }, ix]
      end.max_by { |count, _| count }.last
binding.pry
      group[drip_index].tap do
        group[drip_index] = top_group.drip
      end
    end

    def to_a
      group
    end

    def full?
      group.size == capacity
    end

    private

    attr_reader :group, :capacity, :top_group
  end

  # def build_tree(array)
  #   Node.from funnel
  # end

  class Node
    attr_reader :value
    attr_accessor :left, :right

    class << self
      def from(array)
        seed = array.dup

        root = new seed.shift
        q = [root]

        while q.any?
          node = q.shift

          if seed.first
            node.left = new seed.shift
            q << node.left
          end

          if seed.first
            node.right = new seed.shift
            q << node.right
          end
        end

        root
      end
    end

    def initialize(value, left = nil, right = nil)
      @value = value
      @left = left
      @right = right
    end

    def weight
      1 + (left&.weight).to_i + (right&.weight).to_i
    end

    def to_a
      result = []
      queue = [self]

      while queue.any?
        node = queue.shift

        result << node.value

        queue << node.left if node.left
        queue << node.right if node.right
      end

      result
    end
  end
end
