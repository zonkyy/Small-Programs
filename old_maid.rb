MEMBER = 3

class Player
  attr_accessor :cards

  def initialize(dealed)    # コンストラクタ
    @cards = dealed
    check
  end

  # 同じ数字のカードを捨てる
  def check
    cards.sort!
    1.upto(13) do |i|
      while cards.index(i) != cards.rindex(i)
        cards.delete_at(cards.index i)
        cards.delete_at(cards.rindex i)
      end
    end
  end

  # 引数の数字のカードを引く
  def get(num)
    cards << num
    check
    num
  end

  # カードの中から一枚ランダムで相手に渡す
  def give
    cards.delete_at(rand cards.size)
  end
end



# 配布するカード生成(0はジョーカー)
all_cards = Array.new(13*4){|i| i % 13 + 1}
all_cards << 0
all_cards = all_cards.sort_by{rand}

# カードを人数分に分割して、それを所持したプレイヤーオブジェクト作成
players = []
all_cards.each_slice(53/MEMBER + 1).to_a.each_with_index do |card, i|
  players.push(Player.new(card.clone))
end

# ババ抜き開始
players.each do |p|
  p.check
end

i = -1
while !players[i].cards.empty?
  players.each_with_index do |p, num|
    print "player#{num}: #{p.cards.join(',')}\n"
  end
  print "----------------------------------\n"
  i = (i + 1) % MEMBER
  move_card = players[i].get(players[(i+1) % MEMBER].give)
  print "player#{i} get #{move_card}\n"

  if players[(i+1)%MEMBER].cards.empty?
    i += 1
    break
  end
end

# ゲーム終了
players.each_with_index do |p, num|
  print "player#{num}: #{p.cards.join(',')}\n"
end
print "Winner is player#{i}\n"
