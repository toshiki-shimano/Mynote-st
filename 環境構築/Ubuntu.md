# Ubuntuの環境構築メモ

## コマンドメモ

1. codeと打つとvscodeが開かれる

## その他メモ

1. ターミナルでrails sで起動した後、グーグルで立ち上げる時にはhttpsの方ではなく、httpで立ち上げること

## Rubyのバージョンアップについての解決

* 問題：速習（P58）でRubyのアップデートが出来ない。（gem update --systemと打つとnameエラー）

```error
/usr/lib/ruby/vendor_ruby/rubygems/defaults/operating_system.rb:50:in `<class:Specification>': undefined method `rubyforge_project=' for class `Gem::Specification' (NameError)
```

⇒最後の方のundefinedmethod`rubyforge_project=' for class とはrubyforge_projectが定義されてない  
⇒gem -v と打つと3.1.2出るのでバージョンが違うのでアップデート出来ない模様。

★解決★

① [同じ悩みのひと](https://github.com/rubygems/rubygems/issues/3831):ここにあり

> rubyforge_project =はRubyGems 3.1.4で削除されましたメソッドrubyforge_project =が存在しない場合は問題ありません

② 修正方法も書かれているので、赤いマスを消して、緑のマスを追加する。これをnameエラーが起きているファイルで追記すればよい

③今回問題を起こしたファイルは、operating_system.rbである。なので、ターミナルでcdコマンドで  
`cd /usr/lib/ruby/vendor_ruby/rubygems/defaults`  
と打って、
`sudo code operating_system.rb`
と打つ  

⇒すると、`sudo: code: command not found`と出てしまう。これは、vscode上にsudoというコマンドが存在しないためである。なので、  
`sudo chmod 777 operating_system.rb`と打つと、そのパーミッションを変更出来る。777はユーザーもグループも外部ユーザーも許可。これで、`code operating_system.rb`と打って、vscodeへ。  

④ctrl + f で該当文字を検索、修正。最後に`sudo gem update --system` と打つとインストール成功。次に、gem -vと打つと3.1.4と表示される。 