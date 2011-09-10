require "pp"

QUESTION = [[1,0,0,7,0,0,6,0,0],
            [0,2,0,0,0,0,0,5,0],
            [0,0,3,0,0,9,0,0,0],
            [7,0,0,4,0,0,0,0,8],
            [0,0,0,0,5,0,0,2,0],
            [0,0,0,0,0,6,1,0,0],
            [4,0,2,1,0,0,7,0,0],
            [0,0,0,0,0,7,0,8,0],
            [6,0,0,0,2,0,0,0,9]]


class Answer
  WIDTH = 9
  HEIGHT = 9

  attr_reader :field, :answer

  def initialize(question = QUESTION)
    @field = Array.new(HEIGHT).map!{Array.new(WIDTH, 0).map!{Array.new}}
    @answer = Marshal.load(Marshal.dump(question))
  end

  # @answerを解答にしてそれを返す
  # 解答できない問題に対してはエラー出力
  def start
    # 全ての空白に記入可能な数字の配列を与える
    create_init_field

    # pp @field
    # exit
    while @answer.flatten.index(0)
      @field.each_with_index do |row, row_num|
        row.each_with_index do |writable_nums, col_num|
          if writable_nums.length == 1
            # 記入候補が1つの空白を埋めて、fieldを更新
            p "1: " + row_num.to_s + ", " + col_num.to_s + ", " + writable_nums[0].to_s
            write_num(writable_nums[0], row_num, col_num)
          elsif writable_nums.length > 1
            # 各空白で記入候補の数字を見ていき、
            # その数字が行、列、ボックスでそこにしかなければその空白に記入してfieldを更新
            writable_nums.each do |num|
              if !exist_writable_num_in_row_except_here?(num, row_num, col_num) or
                  !exist_writable_num_in_col_except_here?(num, row_num, col_num) or
                  !exist_writable_num_in_box_except_here?(num, row_num, col_num)
                write_num(num, row_num, col_num)
                p "2: " + row_num.to_s + ", " + col_num.to_s + ", " + num.to_s
              end
            end
          end
        end
      end
    end

    return @answer
  end



  ### 以下、プライベートメソッド #########################
  private

  def write_num(written_num, row_num, col_num)
    @answer[row_num][col_num] = written_num
    @field[row_num][col_num] = []
    delete_num_in_row_col_box(written_num, row_num, col_num)
  end

  def exist_writable_num_in_row_except_here?(num, row_num, col_num)
    @field[row_num][col_num].delete(num)
    exist_in_row = @field[row_num].any? do |writable_nums|
      writable_nums.index(num)
    end
    @field[row_num][col_num].push(num).sort
    p "row" if not exist_in_row
    exist_in_row
  end

  def exist_writable_num_in_col_except_here?(num, row_num, col_num)
    @field[row_num][col_num].delete(num)
    exist_in_col = @field.any? do |row|
      row[col_num].index(num)
    end
    @field[row_num][col_num].push(num).sort
    p "col" if not exist_in_col
    exist_in_col
  end

  def exist_writable_num_in_box_except_here?(num, row_num, col_num)
    @field[row_num][col_num].delete(num)
    range_row = box_range(row_num)
    range_col = box_range(col_num)
    exist_in_box = range_row.any? do |r_num|
      range_col.any? do |c_num|
        @field[r_num][c_num].index(num)
      end
    end
    @field[row_num][col_num].push(num).sort
    p "box" if not exist_in_box
    exist_in_box
  end

  def delete_num_in_row_col_box(num, row_num, col_num)
    delete_num_in_row(num, row_num)
    delete_num_in_col(num, col_num)
    delete_num_in_box(num, row_num, col_num)
  end

  def delete_num_in_row(num, row_num)
    @field[row_num].each_index do |col_num|
      @field[row_num][col_num].delete(num)
    end
  end

  def delete_num_in_col(num, col_num)
    @field.each_index do |row_num|
      @field[row_num][col_num].delete(num)
    end
  end

  def delete_num_in_box(num, row_num, col_num)
    range_row = box_range(row_num)
    range_col = box_range(col_num)
    range_row.each do |r_num|
      range_col.each do |c_num|
        @field[r_num][c_num].delete(num)
      end
    end
  end

  def create_init_field
    @field.each_with_index do |row, row_num|
      row.each_index do |col_num|
        @field[row_num][col_num] = writable_nums_in_the_blank(row_num, col_num)
      end
    end
  end

  # (x, y)に書き込める数字を返す
  def writable_nums_in_the_blank(row_num, col_num)
    (1..9).find_all do |i|
      (@answer[row_num][col_num] == 0) and
        !exist_num_in_row?(i, row_num, col_num) and
        !exist_num_in_column?(i, row_num, col_num) and
        !exist_num_in_box?(i, row_num, col_num)
    end
  end

  # (x, y)の行にnumが存在しているか調べる
  def exist_num_in_row?(num, row_num, col_num)
    @answer[row_num].any? do |e|
      e == num
    end
  end

  # (x, y)の列にnumが存在しているか調べる
  def exist_num_in_column?(num, row_num, col_num)
    @answer.any? do |row|
      row[col_num] == num
    end
  end

  # ボックスの範囲
  def box_range(i)
    (i/3)*3..((i/3)*3 + 2)
  end

  # (x, y)と同じボックスにnumが存在してるか調べる
  def exist_num_in_box?(num, row_num, col_num)
    range_row = box_range(row_num)
    range_col = box_range(col_num)
    range_row.any? do |y|
      range_col.any? do |x|
        @answer[y][x] == num
      end
    end
  end

end


a = Answer.new
pp a.start


