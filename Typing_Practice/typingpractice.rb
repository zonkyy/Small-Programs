SPACE_INTERVAL = 3

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
      ch_ary << " " if (i % SPACE_INTERVAL == (SPACE_INTERVAL - 1))
    end

    print ch_ary
    puts
  end
end

tp = TypingPractice.new
tp.output(*ARGV)
