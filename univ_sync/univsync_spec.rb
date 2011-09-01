require 'univsync'

describe UnivSync, "は、" do
  before do
    @usync = UnivSync.new
  end

  it "Windowsのパスの配列それぞれをcygwinのパスに変換し、スペースで接続した文字列にできる" do
    @usync.send(:format_src_dir, ["d:/home"]).should == "/cygdrive/d/home"
    @usync.send(:format_src_dir, ["d:/home", "c:/eclipse"]).should == "/cygdrive/d/home /cygdrive/c/eclipse"
  end

  it "Windowsのパスの配列それぞれをcygwinのパスに変換できる" do
    @usync.send(:winpath_to_cygpath, ["d:/home"]).should == ["/cygdrive/d/home"]
    @usync.send(:winpath_to_cygpath, ["d:/home", "c:/eclipse"]).should == ["/cygdrive/d/home", "/cygdrive/c/eclipse"]
  end

  it "パスの配列それぞれに --option=\"\" がつけられる" do
    @usync.send(:add_option, ["/cygdrive/d/home"], 'opt').should == ['--opt="/cygdrive/d/home"']
    @usync.send(:add_option, ["/cygdrive/d/home", "/cygdrive/c/eclipse"], 'opt').should == ['--opt="/cygdrive/d/home"', '--opt="/cygdrive/c/eclipse"']
  end

  it "exclude の設定が正しく行える" do
    @usync.send(:format_exclude_dir, ["d:/home"]).should == '--exclude="/cygdrive/d/home"'
    @usync.send(:format_exclude_dir, ["d:/home", "c:/eclipse"]).should == "--exclude=\"/cygdrive/d/home\" --exclude=\"/cygdrive/c/eclipse\""
  end

  it "include の設定が正しく行える" do
    @usync.send(:format_include_dir, ["d:/home"]).should == '--include="/cygdrive/d/home"'
    @usync.send(:format_include_dir, ["d:/home", "c:/eclipse"]).should == "--include=\"/cygdrive/d/home\" --include=\"/cygdrive/c/eclipse\""
  end

  it "読み込んだ設定から正しいアップロード用rsyncコマンドを返すことができる" do
    UnivSync.upload_command('example_upload_config.yaml').should ==
      'rsync -av --delete --exclude="/cygdrive/d/home/.*" --include="/cygdrive/d/home/.emacs.d" --include="/cygdrive/d/home/.zsh.d" -e ssh /cygdrive/d/home user@host.ac.jp:~/backup'
  end
end


