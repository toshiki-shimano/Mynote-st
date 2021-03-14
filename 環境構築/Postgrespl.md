# Postgresql関連

## postgresqlの登録の流れについて

* 前知識

⇒[参考：posgresqlのコマンド一覧](https://dev.classmethod.jp/articles/postgresql-organize-command/)

1. su postgresはスイッチユーザーの事で、この場合postgresユーザーに切り替えるということである。これをやるとユーザーが変わってしまうので、もしやってしまったら su toshikiと打てば戻れる。ただのpsqlというコマンドだけだと引数にデータベース名も指定されてないのでエラーになってしまう。（FATAL:  database "toshiki" does not exist）

2. configにあるdatabase.ymlにあるデータベース名を一緒に記述して入るとそのDBに入れる  
⇒`psql willnote_development`（開発用のDBに入る）  
⇒`psql willnote_test`（テスト用のDBに入る）  

3. psql --version でバージョンとインストールされているか調べる

4. psql -l でデータベース一覧表示（管理者がposgresとtoshikiとあるので何らかの流れでtoshikiも作った。posgresは最初にデフォルトの管理者）

5. データベースはアプリケーションの中で消さないといけない為、先にアプリの方を消してしまうと、そのデータベースに潜らないと消せない

* ユーザー登録

1. `sudo -u postgres psql` で中に入る

2. postgres=#に続けて、`create role postgres with createdb login password 'st1234st';` と打つ（既に作られているなら、ERROR:  role "postgres" already existsと出る）

3. `ALTER ROLE postgres WITH PASSWORD 'st1234st';`でパスワードを作成。

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
