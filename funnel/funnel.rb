# frozen_string_literal: true

class Funnel
  CAPACITY = 15

  def initialize
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
    new_content = numbers.first CAPACITY

    while new_content.any?
      groups.each do |g|
        g.fill new_content.shift while new_content.first && !g.full?
      end

      break
    end
  end

  def to_s
    rows.strip
  end

  def drip
    drop = groups.first.drip

    if drop == Group::EMPTY_SOCKET
      nil
    else
      drop
    end
  end

  def to_a
    groups
      .each_with_object([]) { |g, result| result.concat g.to_a }
      .reject { |el| el == Group::EMPTY_SOCKET }
  end

  private

  attr_reader :groups

  def rows
    4.downto(0).zip(groups).map do |row, group|
      prepad row, nth_row(group.to_a)
    end.reverse.join "\n"
  end

  def nth_row(elements)
    string = elements.map do |el|
      if el == Group::EMPTY_SOCKET
        ' '
      else
        el
      end
    end.join ' '

    "\\#{string}/"
  end

  def prepad(n, string)
    "#{' ' * n}#{string}"
  end

  class Group
    EMPTY_SOCKET = '*'

    def initialize(top_group, capacity)
      @top_group = top_group
      @capacity = capacity
      @group = [EMPTY_SOCKET] * capacity
    end

    def fill(el)
      return if full?

      insertion_index =
        group.find_index { |socket| socket == EMPTY_SOCKET }

      if insertion_index
        group[insertion_index] = el
      else
        group << el
      end
    end

    def drip(start_index = 0)
      return drip_element! start_index if no_parent?

      drip_index = index_by_weight.max_by(&:first).last

      group[drip_index].tap do
        group[drip_index] = top_group.drip drip_index
      end
    end

    def to_a
      group
    end

    def full?
      group.count { |el| el != EMPTY_SOCKET } == capacity
    end

    def weight(at_index)
      if no_parent?
        return group[at_index..at_index.succ].count do |el|
          el != EMPTY_SOCKET
        end
      end

      top_group.weight at_index
    end

    private

    def no_parent?
      top_group.nil? ||
        top_group.to_a.none? { |el| el != EMPTY_SOCKET }
    end

    def index_by_weight
      group.each_with_index.map do |_, ix|
        [top_group.weight(ix), ix]
      end
    end

    def calculate_index(offset)
      replace_index =
        group[offset..-1].find_index do |socket|
          socket != EMPTY_SOCKET
        end || 0

      replace_index + offset
    end

    def drip_element!(start_index)
      replace_index = calculate_index start_index

      group[replace_index].tap do
        group[replace_index] = EMPTY_SOCKET
      end
    end

    attr_reader :group, :capacity, :top_group
  end
end
