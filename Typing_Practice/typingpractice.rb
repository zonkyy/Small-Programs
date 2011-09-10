SPACE_INTERVAL = 4

class TypingPractice
  def initialize
    @hiragana = %w[あ い う え お か き く け こ さ し す せ そ た ち つ て と な に ぬ ね の は ひ ふ へ ほ ま み む め も や ゆ よ ら り る れ ろ わ を ん]
  end

  def output(first_chr, last_chr, num)
    first_idx = @hiragana.index first_chr
    last_idx = @hiragana.index last_chr
    ch_ary = []
    num.to_i.times do |i|
      ch_ary << @hiragana[(i % (last_idx - first_idx + 1)) + first_idx]
    end

    ch_ary.sort_by{rand}.each_with_index do |c, i|
      print " " if i % SPACE_INTERVAL == 0
      print c
    end
    puts
  end
end

tp = TypingPractice.new
tp.output(*ARGV)
