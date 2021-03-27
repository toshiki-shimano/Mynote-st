# Git

## 準備

* 下記を参考にgitbashをインストール
⇒[これを参考にgitbashインストール](https://blog.totsugeki.com/post-279/)
⇒インストールできたら、、[ここを参考に開いてみる](https://www.sejuku.net/blog/72673)
⇒[gitbashのconfigの消し方](https://hacknote.jp/archives/11885/)(gitbashターミナルで設定したconfig等の設定の消し方)

* 次に秘密鍵と公開鍵を作成する

★[gitbashインストール後のフォルダを作るところから書かれている](https://qiita.com/reflet/items/5c6ba6e29fe8436c3185)
⇒🔺注意🔺：最初にフォルダを作成していないとエラーが起きる。パスフレーズは設定しないで空打ちする

★[configの作成](https://yu-report.com/entry/githubSSH)
⇒カギを作成できたら、この記事のconfigの作成という項目をやる

⇒`echo ~`コマンドで現在のホームディレクトリを指す  
⇒無事できればtoshiki配下に.sshディレクトリ内にファイルが作成される

```ruby
Your identification has been saved in /c/Users/toshiki/.ssh/id_rsa 
Your public key has been saved in /c/Users/toshiki/.ssh/id_rsa.pub

# id_rsaが秘密鍵、
# id_rsa.pubが公開鍵:この内容をgithubに登録すると登録したgithub所持者のgithubにキーを使って接続できる
```

* 次にconfigファイルをsshディレクトリ内に作る
⇒githubに公開鍵を設定  
⇒gitbashのターミナルにて、`ssh -T git@github.com`コマンドでカギの接続が出来るか確認（最初は、接続して大丈夫かという質問がくるのでyesを押す）

## 毎回pushやコミットする度にパスワードを聞かれるの防ぐ

★[参考](https://qiita.com/rorensu2236/items/df7d4c2cf621eeddd468)  
⇒ローカルのgitファイルをリモートに繋げる時にURLAで設定しないで、sshで登録をすればいちいちパスワードを聞かれない

## 前知識(🔶全て重要🔶)

★ある時点でのブランチ（master）から分岐して新しいブランチ（feature）を作成したとき、そのブランチで新規ファイル作成、コミットまでやったら、それをリモートにpushする時、、、git push originだと、上流がないと言われる。  
⇒基本は、git push origin ブランチ名！で送信する  
⇒最初の設定で、git push -u origin ブランチ名でやると次は、-uのおかげでgit push originで済む  

★ブランチを変えて、そこでファイルを作成したときに、そのファイルを閉じないで別のブランチにチェックアウトした場合、その画面に残っているファイルは当然未保存状態になる。（**そのブランチでの作業が終わったら、そのファイルを閉じることをやる**）

★githubで直接ブランチを削除した場合、次にローカルのブランチをデリートするが、branch -aをやるとremotes/の形でリモートブランチが残ってしまう。その時は、git fetch -pで一掃できる！
[ここを参考に！](https://noumenon-th.net/programming/2019/12/29/git-branch-d/)

## Gitのルール(やってはいけないこと！を含める)

①`git push -f origin master`の`-f`  
⇒これは強制的に履歴を書き換える、絶対にしない、自分が解決できても、自身の書き換えた履歴でgithubにpushするわけだから、他の人もfast-forwordedになってリベースでdiffを書き換えないといけなくなる)

②masterにpushすること（基本開発環境でmasterにpushすることは無い。必ず自身のブランチにpushする）

③履歴の巻き戻し  
(想定：自身でコミットした後にpushはせず、またファイルを変更してコミット、さらに変更してコミットした時に二つ前のコードに戻したい場合は`^^`で二回戻す)
⇒git reset soft HEAD^^(^^の分戻す。コミットを二回分戻す。ファイルの内容は消えないので、git diffで変更前変更後が確認できる)  
⇒git reset head HEAD^(コミット一回分もどす、ファイルのデータも消えてしまうので自身の開発のみ)  
⇒基本はコミットしたら、resetするのではなく修正コミットを出すのが普通  
⇒git commit --amendはコミットのコメントを直すだけ  

④commit push rm -dは絶対に確認を取ること！

⑤別のブランチへ飛ぶ時に今作業していたブランチのファイは保存して閉じること！

◍ローカル内でマージをした時、リモートには反映されてないのでpushが必要だが、、pushは要注意！

◍基本rebaseは要らないが、、pullのrebaseは使えそう？他にも、コミット複数やり直しのrebase -i HEAD~3

### ポートフォリオの上げ方

* gitignoreファイルに.envファイル（メーラー機能を使っているなら）とconfigのmaster.keyファイル（デフォルトでgitignoreにあり）を追加

* pushする場合、リモートはpublicにすること（プライベートだと相手が見えない）

①`taskleaf`というプロジェクトがあるなら、`taskleaf`がカレントディレクトリの状態で始める。（railsで作ったプロジェクトは最初からinit(初期化済み)されている）  
②`git add .`  
③`git commit -m 'テスト'`  

④githubでリポジトリをつくる。（見せるならpublicで、nameはプロジェクト名で）  
⇒sshURLを確認  
⑤`git remote add origin sshのURL`  
（ローカルのリモートにsshのリモートをoriginという名前で登録する）  
⑥`git push origin master`  
（リモート名とブランチ名はセット！）  

### 基本操作

★プロジェクトのファイルを一部変更。そのファイルをステージングする時には、`git add パス名` になるが、このパスを間違えるとうまくいかないので、正式を見るには`git status`で見るとパスが分かる。  
⇒ファイルを変更した後に、もし完全にスペースなども考えファイルのコードを戻せるなら手動で戻すか、Ctrlとｚで最後まで戻せるなら、それを再保存すれば変更状態は解除される。  

⇒ステージングしたファイルの内、特定のファイルをコミットしたい場合は

```git
git commit -m 'test' --controllers.rb
git commit -m 'test' --controllers.rb test.rb ＃複数の場合
```

⇒だたこれは、ステージングさえしなければ良い。コミットするものだけをステージングするようにしていく。


### rebase

* techpitのgit入門へ＋サルさんのGit入門（rebaseとtag見る）

★テックピットのrebaseについては、サル入門Gitの方が正しい！
（rebaseを使った、pushをしていないファイルの二つ以上前のコミットの修正の仕方。）

* テックピットメモ  
⇒２－５のtreeコマンド：gitbashでecho ~でホームディレクトリはUser/toshikiだとわかるので、cdでそこまでいき、touchで.bashrcを作成。そこにコードを書いて、gitbashを再起動すると使える

### gitコマンド

★git branch -a
⇒作成されているブランチの一覧を表示

★git fetch -p
⇒ローカルとローカルのリモートブランチを削除した後に、まだ削除されたはずのブランチが残ってしまっていたら、これで消せる。

★git commit --amend
⇒コミットした後に、直前のコミットの内容を変更したい時に使う