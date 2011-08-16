KEY_CODE_0 = 48
KEY_CODE_A = 65
KEY_CODE_F1 = 112

# キーハッシュの構成
# hash["A"] => 仮想キー
key_code = {
  "!"     => 0,                  # '!'はキーの削除に使用
  "BS"    => 8,
  "ENT"   => 13,
  "ESC"   => 27,
  "SPC"   => 32,
  "P_UP"  => 33,
  "P_DN"  => 34,
  "END"   => 35,
  "HOME"  => 36,
  "←"    => 37,
  "↑"    => 38,
  "→"    => 39,
  "↓"    => 40,
  "INS"   => 45,
  "DEL"   => 46,
  ":"     => 186,
  ";"     => 187,
  ","     => 188,
  "MINUS" => 189,
  "."     => 190,
  "/"     => 191,
  "@"     => 192,
  "\\"    => 226,
}

i = KEY_CODE_0
("0".."9").each do |c|
  key_code[c] = i
  i += 1
end

i = KEY_CODE_A
("a".."z").each do |c|
  key_code[c] = i
  i += 1
end

i = KEY_CODE_F1
1.upto(12) do |c|
  key_code["F#{c}"] = i
  i += 1
end

# プレスキーのハッシュ構成
press_code = {
  "S" => 1000,
  "C" => 2000,
  "M" => 4000
}

# セクション配列作成
SECTION_STR = ["[NORMAL]", "[TVIEW]", "[GVIEW]", "[MENUD]", "[IFIND]"]



# 出力ファイルの先頭に判別用文字列を記述
open("AFXW.KEY", "w") {|f|
  f.puts "[KEYCUST]", "ON=1"
}



# 定義ファイル処理
open("key.txt") {|f|
  num = 0
  while line = f.gets
    # 空行、先頭が'#'の行は無視
    line.strip!
    if line.empty? or line[0] == ?#
      next
    end
    # 識別用文字列なら出力して次へ
    if SECTION_STR.index(line)
      open("AFXW.KEY", "a") {|out_f|
        out_f.puts line
      }
      num = 0
      next
    end

    # "|"で分割
    # 先頭が空白ならキー変更無し(次の行へ)
    split_line = line.split("|")
    my_key = split_line[0].strip
    afxw_key_code = split_line[1].strip.split("|")[0].to_i
    next if my_key.empty?

    # "|" 分割の最初でマッチング("-" 分割)
    # ただし、"S--"は先に"S-MINUS"に書き換えておく
    my_key = my_key.gsub("--", "-MINUS")
    my_key = my_key.split("-")

    # 仮想コード作成
    new_code = 0
    def_range = false
    first_chr = 0
    range = 0
    my_key.each do |e|
      if pc = press_code[e]
        new_code += pc
        next
      end

      if kc = key_code[e]
        new_code += kc
        next
      end

      if e[0] == ?[
        first_chr = e[1].chr
        new_code += key_code[first_chr]
        next
      end

      if e[-1] == ?]
        last_chr = e[0].chr
        range = first_chr..last_chr
        def_range = true
        next
      end

      STDERR.puts "以下の入力に誤りがあります。", line
      exit
    end
    # 書き込み
    open("AFXW.KEY", "a") {|out_f|
      if def_range
        range.each do |c|
          out_f.puts "K#{"%04d" % num}=\"#{"%04d" % new_code}:#{"%04d" % afxw_key_code}\""
          new_code += 1
          afxw_key_code += 1
          num += 1
        end
      else
        out_f.puts "K#{"%04d" % num}=\"#{"%04d" % new_code}:#{"%04d" % afxw_key_code}\""
        num += 1
      end
    }
  end
}

