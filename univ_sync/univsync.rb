require 'yaml'
require 'pp'

# yamlファイルから設定を読み込み、rsyncコマンドを生成する
class UnivSync

  # アップロード用コマンドを返すクラスメソッド
  def self.upload_command(yaml_file = 'upload_config.yaml')
    usync = UnivSync.new

    yaml_data = YAML.load_file(yaml_file)
    src_dir = usync.format_src_dir(yaml_data["src_dir"])
    dest_host = yaml_data["dest_host"][0]
    dest_dir = yaml_data["dest_dir"][0]
    include_opt = usync.format_include_dir(yaml_data["include"]) unless yaml_data["include"].empty?
    exclude_opt = usync.format_exclude_dir(yaml_data["exclude"]) unless yaml_data["exclude"].empty?

    "rsync -av --delete #{exclude_opt} #{include_opt} -e ssh #{src_dir} #{dest_host}:#{dest_dir}"
  end

  # ダウンロード用コマンドを返すクラスメソッド
  def self.download_command
  end


  # Windowsのパスをcygwinのパスに変換して
  # スペースで接続した文字列として返す
  def format_src_dir(src_dir_ary)
    winpath_to_cygpath(src_dir_ary).join " "
  end

  # 配列に入ったWindowsのパスをそれぞれcygwinのパスに変換して返す
  def winpath_to_cygpath(dir_ary)
    dir_ary.collect {|dir| dir.sub(/(.):\//, '/cygdrive/\1/')}
  end

  # 配列の全てのディレクトリに --option="" をつけて返す
  def add_option(dir_ary, option)
    dir_ary.collect do |dir|
      str = "--#{option}="
      str += dir.sub(/^(.+)$/, '"\1"')
    end
  end

  # 全てのディレクトリに --exclude="" をつけて
  # スペースで接続した文字列として返す
  def format_exclude_dir(exclude_dir_ary)
    add_option(winpath_to_cygpath(exclude_dir_ary), "exclude").join " "
  end

  # 全てのディレクトリに --include="" をつけて
  # スペースで接続した文字列として返す
  def format_include_dir(exclude_dir_ary)
    exclude_dir_ary = winpath_to_cygpath(exclude_dir_ary).collect {|dir| dir.sub(/^(.+)$/, '--include="\1"')}
    exclude_dir_ary.join " "
  end

end
