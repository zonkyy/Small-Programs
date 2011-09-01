class Answer
  WIDTH = 9
  HEIGHT = 9

  attr_accessor :field

  def initialize
    @field = Array.new(HEIGHT).map!{Array.new(WIDTH, 0).map!{Array.new}}
    @question = [[1,0,0,7,0,0,6,0,0],
                 [0,2,0,0,0,0,0,5,0],
                 [0,0,3,0,0,9,0,0,0],
                 [7,0,0,4,0,0,0,0,8],
                 [0,0,0,0,5,0,0,2,0],
                 [2,0,0,0,0,6,1,0,0],
                 [4,0,2,1,0,0,7,0,0],
                 [0,0,0,0,0,7,0,8,0],
                 [6,0,0,0,2,0,0,0,9]]
    field_init_j
  end

  def field_init_j
    a = (1..8).find_all do |i|
      !exist_num_in_row?(i, 0, 1)
    end
    p a
  end

  def field_init
    HEIGHT.times do |y|
      WIDTH.times do |x|
        if @question[x][y].zero?
          
        end
      end
    end
  end

  # (x, y)の行にnumが存在しているか調べる
  def exist_num_in_row?(num, x, y)
    @question[x].any? do |e|
      e == num
    end
  end

  # (x, y)の列にnumが存在しているか調べる
  def exist_num_in_column?(num, x, y)
    @field.any? do |row|
      row[y] == num
    end
  end

  # (x, y)と同じボックスにnumが存在してるか調べる
  def exist_num_in_box?(num, x, y)
    range_x = box_range(x)
    range_y = box_range(y)
    range_x.any? do |row|
      range_y.any? do |column|
        @field[row][column] == num
      end
    end
  end

end


a = Answer.new

