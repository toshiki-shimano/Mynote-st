# Postgresql関連

## postgresqlの登録の流れについて

* 前知識

1. su  postgresはスイッチユーザーのことなので、この場合postgresユーザーに切り替えるということであり、su  postgresについては、これをやるとユーザーが変わってしまうので、もしやってしまったらsu  toshikiと打てば戻れる



## エラー関連

★問題：速習railsのP63において`psql postgres`と打つと、

```error
createdb: could not connect to database postgres: FATAL:  role "toshki" does not exist
```

と出てしまう。`sudo su postgres-c'createuser -s {toshiki}'`をもう一度打っても、toshikiは存在すると出てしまう。  
⇒まずテキスト通りにいくと、パスワードの設定をする工程がなかったので、調べてみた。  

[パスワードの設定](https://qiita.com/sibakenY/items/407b721ad1bd0975bd00)

⇒パスワードの設定をした後に、su postgresでサーバーへ接続するとpsqlと打ってきちんと表示された。psqlと打ってpostgres=#で止まったら￥qで抜けられる。  
⇒su  postgres をしてからsudoを使うとsudoers fileみたいなメッセージでエラーになる。sudoを打たずにservice postgresql startなどのコマンドはできるみたいだが、apt installなどのインストールができないので、一度閉じてpostgresに接続しないで再びsudo apt install ～をやるとできた。
