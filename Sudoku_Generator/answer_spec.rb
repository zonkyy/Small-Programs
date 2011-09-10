require 'answer'

WIDTH = 9
HEIGHT = 9
SPEC_QUESTION = [[1,0,0,7,0,0,6,0,0],
                 [0,2,0,0,0,0,0,5,0],
                 [0,0,3,0,0,9,0,0,0],
                 [7,0,0,4,0,0,0,0,8],
                 [0,0,0,0,5,0,0,2,0],
                 [0,0,0,0,0,6,1,0,0],
                 [4,0,2,1,0,0,7,0,0],
                 [0,0,0,0,0,7,0,8,0],
                 [6,0,0,0,2,0,0,0,9]]

describe Answer, "が初期化されたとき、" do
  before do
    @answer = Answer.new
  end

  it "@field は 9*9*0 の配列である" do
    @answer.field.should have(9).items
    @answer.field.each do |row|
      row.should have(9).items
    end
  end

  it "@field は空の配列で埋められている" do
    @answer.field.each do |row|
      row.each do |stack|
        stack.should be_empty
      end
    end
  end
end


describe Answer, "は、" do
  before do
    @ans = Answer.new(SPEC_QUESTION)
  end

  it "(行, 列) と同じ行に num と同じ値がないことをチェックできる" do
    @ans.send(:exist_num_in_row?, 1, 0, 1).should be_true
    @ans.send(:exist_num_in_row?, 2, 0, 1).should be_false
    @ans.send(:exist_num_in_row?, 3, 0, 1).should be_false
    @ans.send(:exist_num_in_row?, 4, 0, 1).should be_false
    @ans.send(:exist_num_in_row?, 5, 0, 1).should be_false
    @ans.send(:exist_num_in_row?, 6, 0, 1).should be_true
    @ans.send(:exist_num_in_row?, 7, 0, 1).should be_true
    @ans.send(:exist_num_in_row?, 8, 0, 1).should be_false
    @ans.send(:exist_num_in_row?, 9, 0, 1).should be_false
  end

  it "(行, 列) と同じ列に num と同じ値がないことをチェックできる" do
    @ans.send(:exist_num_in_column?, 1, 1, 0).should be_true
    @ans.send(:exist_num_in_column?, 2, 1, 0).should be_false
    @ans.send(:exist_num_in_column?, 3, 1, 0).should be_false
    @ans.send(:exist_num_in_column?, 4, 1, 0).should be_true
    @ans.send(:exist_num_in_column?, 5, 1, 0).should be_false
    @ans.send(:exist_num_in_column?, 6, 1, 0).should be_true
    @ans.send(:exist_num_in_column?, 7, 1, 0).should be_true
    @ans.send(:exist_num_in_column?, 8, 1, 0).should be_false
    @ans.send(:exist_num_in_column?, 9, 1, 0).should be_false
  end

  it "(行, 列) のボックス範囲を求めることができる" do
    @ans.send(:box_range, 0).should eql(0..2)
    @ans.send(:box_range, 2).should eql(0..2)
    @ans.send(:box_range, 3).should eql(3..5)
    @ans.send(:box_range, 5).should eql(3..5)
    @ans.send(:box_range, 6).should eql(6..8)
    @ans.send(:box_range, 8).should eql(6..8)
  end

  it "(行, 列) と同じボックスに num と同じ値がないことをチェックできる" do
    @ans.send(:exist_num_in_box?, 1, 1, 2).should be_true
    @ans.send(:exist_num_in_box?, 2, 1, 2).should be_true
    @ans.send(:exist_num_in_box?, 3, 1, 2).should be_true
    @ans.send(:exist_num_in_box?, 4, 1, 2).should be_false
    @ans.send(:exist_num_in_box?, 5, 1, 2).should be_false
    @ans.send(:exist_num_in_box?, 6, 1, 2).should be_false
    @ans.send(:exist_num_in_box?, 7, 1, 2).should be_false
    @ans.send(:exist_num_in_box?, 8, 1, 2).should be_false
    @ans.send(:exist_num_in_box?, 9, 1, 2).should be_false
  end

  it "(行, 列) に記入可能な数字の配列を作成できる" do
    @ans.send(:writable_nums_in_the_blank, 2, 0).should == [5, 8]
    @ans.send(:writable_nums_in_the_blank, 0, 0).should == []
  end

  it "解答を作成できる" do
    @ans.start.should == [[1,8,4,7,3,5,6,9,2],
                          [9,2,7,6,8,4,3,5,1],
                          [5,6,3,2,1,9,8,7,4],
                          [7,3,1,4,9,2,5,6,8],
                          [8,4,6,3,5,1,9,2,7],
                          [2,5,9,8,7,6,1,4,3],
                          [4,9,2,1,6,8,7,3,5],
                          [3,1,5,9,4,7,2,8,6],
                          [6,7,8,5,2,3,4,1,9]]
  end
end


describe Answer, "はfieldを初期化した後、" do
  before do
    @ans = Answer.new(SPEC_QUESTION)
    @ans.send(:create_init_field)
  end

  it "記入可能な数字の配列を各空白に配置した初期fieldを作成できる" do
    @ans.field[0][0].should == []
    @ans.field[0][1].should == [4, 5, 8, 9]
  end

  it "行のそれぞれの配列からある値を削除できる" do
    @ans.send(:delete_num_in_row, 3, 0)
    @ans.field[0][0].should == []
    @ans.field[0][1].should == [4, 5, 8, 9]
    @ans.field[0][4].should == [4, 8]
  end

  it "列のそれぞれの配列からある値を削除できる" do
    @ans.send(:delete_num_in_col, 5, 0)
    @ans.field[0][0].should == []
    @ans.field[1][0].should == [8, 9]
    @ans.field[2][0].should == [8]
  end

  it "ボックスのそれぞれの配列からある値を削除できる" do
    @ans.send(:delete_num_in_box, 7, 0, 0)
    @ans.field[1][1].should == []
    @ans.field[1][0].should == [8, 9]
    @ans.field[2][1].should == [4, 5, 6, 8]
  end

  it "行、列、ボックスのそれぞれの配列からある値を削除できる" do
    @ans.send(:delete_num_in_row_col_box, 5, 0, 0)
    @ans.field[0][5].should == [2, 3, 4, 8]
    @ans.field[2][0].should == [8]
    @ans.field[2][1].should == [4, 6, 7, 8]
  end

  it "その列(ただしその場所自体は除く)にある値が書き込めるか調べることができる" do
    @ans.send(:exist_writable_num_in_row_except_here?, 1, 3, 5).should be_true
    @ans.send(:exist_writable_num_in_row_except_here?, 2, 3, 5).should be_false
    @ans.send(:exist_writable_num_in_row_except_here?, 7, 3, 5).should be_false
  end

  it "その行(ただしその場所自体は除く)にある値が書き込めるか調べることができる" do
    @ans.send(:exist_writable_num_in_col_except_here?, 9, 5, 0).should be_true
    @ans.send(:exist_writable_num_in_col_except_here?, 2, 5, 0).should be_false
    @ans.send(:exist_writable_num_in_col_except_here?, 7, 5, 0).should be_false
  end

  it "そのボックス(ただしその場所自体は除く)にある値が書き込めるか調べることができる" do
    @ans.send(:exist_writable_num_in_box_except_here?, 1, 5, 0).should be_true
    @ans.send(:exist_writable_num_in_box_except_here?, 2, 5, 0).should be_false
    @ans.send(:exist_writable_num_in_box_except_here?, 7, 5, 0).should be_false
  end

  it "書き込みが行える" do
    @ans.send(:write_num, 5, 0, 2)
    @ans.answer.should == [[1,0,5,7,0,0,6,0,0],
                           [0,2,0,0,0,0,0,5,0],
                           [0,0,3,0,0,9,0,0,0],
                           [7,0,0,4,0,0,0,0,8],
                           [0,0,0,0,5,0,0,2,0],
                           [0,0,0,0,0,6,1,0,0],
                           [4,0,2,1,0,0,7,0,0],
                           [0,0,0,0,0,7,0,8,0],
                           [6,0,0,0,2,0,0,0,9]]
    @ans.field[0][5].should == [2, 3, 4, 8]
    @ans.field[3][2].should == [1, 6, 9]
    @ans.field[2][1].should == [4, 6, 7, 8]
  end

end
