# Viエディタなどの操作について

## .bash_profileについて

⇒ターミナル起動時の状態`ls  -a`を打つと、ドット付きのファイルのリストが出る。そこに、.bash_profileがあれば、そのファイルは存在する。ターミナルで`vim ~/.bash_profile`を打つと、編集ができる。その時、何か入力をして保存せず消してしまうと別の.swpというファイルが残され、次に編集するため`vim ~/.bash_profile`を打つとエラーのようなものが起きる。  
`エラー：Swap file "~/.bash_profile.swp" already exists!`

◆参考◆  
⇒[vimのswpエラー](https://qiita.com/hiroyukiwk/items/01d7f7ada20adffe5c74)

⇒`ls  -la`コマンドで.swpファイルがあるのを確認して、`rm .bash_profile.swp`で削除。

## 編集の仕方

* `vim ~/.bash_profile`と打つと、画面が変わるので、`i`を押すと書けるようになる。最初には何か書いてあるので、一番右までいってenterを押せば、次の行に行く。

* 書き終わったら、escボタンを押すと、再びコマンドモードになるので、そこで`：ｗｑ`と打つと保存して抜けられる。

* 出来たら、ターミナルで`source ~/.bash_profile`で反映する。
