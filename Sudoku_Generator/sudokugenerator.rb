class SudokuGenerator
  WIDTH = 9
  HEIGHT = 9

  attr_accessor :field

  def initialize
    @field = Array.new(HEIGHT).map!{Array.new(WIDTH, 0)}
  end

  def can_write?(num, x, y)
    if exist_num_in_row?(num, x, y) or exist_num_in_column?(num, x, y) or exist_num_in_box?(num, x, y)
      false
    else
      true
    end
  end

  # (x, y)の行にnumが存在しているか調べる
  def exist_num_in_row?(num, x, y)
    @field[x].any? do |e|
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

  # 作成した解答を配列で返す
  def generate_ans_field
    reflexive(0, 0)
  end

  # (x, y)に値を埋める
  def reflexive(x, y)
    if x >= 9
      output
      exit
    end

    insert_nums_ary = [1, 2, 3, 4, 5, 6, 7, 8, 9].sort_by{rand}

    insert_nums_ary.each do |num|
      if can_write?(num, x, y)
        @field[x][y] = num
        if y >= 8
          reflexive(x+1, 0)
        else
          reflexive(x, y+1)
        end
      end
    end

    @field[x][y] = 0
  end


  private

  # ボックスの範囲
  def box_range(i)
    (i/3)*3..((i/3)*3 + 2)
  end

  def output
    row_count = 0
    @field.each do |row|
      count = 0
      row.each do |i|
        print i
        count += 1
        print '|' if count == 3 or count == 6
      end

      puts
      row_count += 1
      puts '-----------' if row_count == 3 or row_count == 6
    end
  end

end



generator = SudokuGenerator.new
generator.generate_ans_field
