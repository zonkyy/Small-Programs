require 'tempfile'


def make_html_file(f, title, text)
  f.puts '<html>'
  f.puts '<head>'
  f.puts '<meta name="viewport" content="width = 450" />'
  f.puts "<title>#{title}</title>"
  f.puts '</head>'
  f.puts '<body>'
  f.puts text
  f.puts '</body>'
  f.puts '</html>'
end



ARGV.each do |filename|
  `nkf -w -Lu #{filename} > euc.#{filename}` # -Lu :改行を LF にする
  `mv -f euc.#{filename} #{filename}`
end
text = ARGF.read

# 特殊文字の変換
text.gsub!("<", "&lt;")
text.gsub!(">", "&gt;")
text.gsub!("&", "&amp;")
text.gsub!('"', "&quot;")

# 不必要な文字列の削除
text.gsub!(/\n\-.+\n.+\n/, "<HR>\n")
text.gsub!(/\n\s*\n/, "<br>\n")

Tempfile.open("novel.tmp") { |tmpf|
  tmpf.write text
  tmpf.close

  tmpf.open
  puts tmpf.gets

  title = nil
  text = ""
  while line = tmpf.gets
    if (line =~ /(Prologue|Epilogue|Chapter\s*\d+)/)
      tmptitle = $1
      if title
        open("#{title}.html", "w") {|f| make_html_file(f, title, text)}
        text = ""
      end
      title = tmptitle
      text << "<h1>#{title}</h1>\n"
    else
      text << line
    end
  end

  open("#{title}.html", "w") {|f| make_html_file(f, title, text)}
}
