class Node
attr_accessor :coordinates, :parent, :y, :x
  def initialize(coordinates=nil, parent=nil, x=nil, y=nil)
    @coordinates = coordinates
    @parent = parent
    @x = x
    @y = y
  end
end

class Knight
attr_accessor :move

@@board = Array(0..7).product(Array(0..7)) # creates an array which contains all squares on the board

  def initialize(start, finish)
    @start = start
    @move = possible_moves(start)
    @finish = finish
  end

  def breadth_first_search(start = @move) 
    begin
      queue = [start] 
      redundant_moves = []
      until queue[0].coordinates == @finish 
        queue << make_children(queue[0], "x", redundant_moves) 
        queue << make_children(queue[0], "y", redundant_moves)
        queue[0].x.each { |val| redundant_moves << val.coordinates }
        queue[0].y.each { |val| redundant_moves << val.coordinates }
        queue.shift
        queue.flatten!
      end
      path_finder(queue[0])
    rescue
      return
    end
  end

  def path_finder(last_child, values=[])
    return values if last_child.nil?
    path_finder(last_child.parent, values)
    values << last_child.coordinates
  end

 private

  def make_children(parent, axis, redundant_moves)
    case axis
      when "x" then parent.x.map! { |axis| possible_moves(axis, parent, redundant_moves) }
      when "y" then parent.y.map! { |axis| possible_moves(axis, parent, redundant_moves) }
    end
  end

  def possible_moves(start, parent=nil, redundant_moves=[])
    node = Node.new(start, parent)

    x_axis = @@board.select do |x| 
      (x[0] + 2 == start[0] || x[0] - 2 == start[0]) && 
      (x[-1] - 1 == start[-1] || x[-1] + 1 == start[-1])
    end
    
    y_axis = @@board.select do |y| 
      (y[0] + 1 == start[0] || y[0] - 1 == start[0]) &&
      (y[-1] - 2 == start[-1] || y[-1] + 2 == start[-1])
    end

    node.x = x_axis.reject { |x| redundant_moves.include?(x) }
    node.y = y_axis.reject { |y| redundant_moves.include?(y) }
    node
  end

end

def knight_moves(start,finish)
  knight = Knight.new(start,finish)
  begin
    path = knight.breadth_first_search
    puts "You've made it in #{path.length - 1} moves, here's your path: "
    path.each_with_index { |move, index| puts "#{move} - #{index}"}
  rescue
    puts "ERROR: Try choosing numbers between 0 and 7 for your axes"
  end
end

knight_moves([3,3],[4,3])
knight_moves([5,6],[2,3])
knight_moves([2,8],[3,3])
knight_moves([3,5],[2,3])
knight_moves([1,0],[7,4])
knight_moves([10,0],[7,4])