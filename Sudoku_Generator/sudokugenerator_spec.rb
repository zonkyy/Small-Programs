require 'sudokugenerator'

WIDTH = 9
HEIGHT = 9

describe SudokuGenerator, "が初期化されたとき、" do
  before do
    @generator = SudokuGenerator.new
  end

  it "@field は 9*9 の配列である" do
    @generator.field.should have(9).items
    @generator.field.each do |row|
      row.should have(9).items
    end
  end

  it "@field は0で埋められている" do
    @generator.field.each do |row|
      row.each do |i|
        i.should == 0
      end
    end
  end
end


describe SudokuGenerator, "は、" do
  before do
    @generator = SudokuGenerator.new
    @generator.field = [[0, 0, 2, 0, 0, 0, 1, 8, 0],
                        [3, 5, 6, 0, 0, 0, 0, 0, 0],
                        [0, 0, 7, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [4, 0, 0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0, 0, 0]]
  end

  it "(x, y) と同じ行に num と同じ値がないことをチェックできる" do
    @generator.exist_num_in_row?(1, 0, 5).should be_true
    @generator.exist_num_in_row?(9, 0, 5).should be_false
  end

  it "(x, y) と同じ列に num と同じ値がないことをチェックできる" do
    @generator.exist_num_in_column?(3, 5, 0).should be_true
    @generator.exist_num_in_column?(1, 5, 0).should be_false
  end

  it "(x, y) のボックス範囲を求めることができる" do
    @generator.send(:box_range, 0).should eql(0..2)
    @generator.send(:box_range, 2).should eql(0..2)
    @generator.send(:box_range, 3).should eql(3..5)
    @generator.send(:box_range, 5).should eql(3..5)
    @generator.send(:box_range, 6).should eql(6..8)
    @generator.send(:box_range, 8).should eql(6..8)
  end

  it "(x, y) と同じボックスに num と同じ値がないことをチェックできる" do
    @generator.exist_num_in_box?(2, 2, 1).should be_true
    @generator.exist_num_in_box?(1, 2, 1).should be_false
  end

  it "(x, y) に num を書き込むことができるかをチェックできる" do
    1.upto(8) do |i|
      @generator.can_write?(i, 0, 0).should be_false
    end
    @generator.can_write?(9, 0, 0).should be_true
  end

  it "解答を作成できる"
end
