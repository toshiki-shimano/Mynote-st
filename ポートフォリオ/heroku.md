# herokuの流れ

## 準備

①herokuで新規登録  
⇒公式で新規登録する。（acceptはとりあえず受け入れるで大丈夫）

②WSl環境におけるHeroku CLIのインストール（そのOS内でherokuコマンドを使えるようにするもの）  
⇒ubuntuで以下のコマンドを今のプロジェクトに入ってない最初のディレクトリで打ち込む  
⇒`curl https://cli-assets.heroku.com/install-ubuntu.sh | sh`  
⇒sudoが求められるのでubuntuのパスワードの認証をする  
⇒少しだけインストールに時間がかかる  
⇒`heroku --version`でインストールされているか確認  

③herokuログイン
⇒🔶重要🔶：herokuへアップしたいアプリにcdをしてから、ログインコマンドする
⇒`heroku login`

```linux
heroku: Press any key to open up the browser to login or q to exit:
```

⇒loginと押し始めたら、herokuのlogin画面が立ち上がり、loginボタンを押したら、そのままログイン認証された。（おそらくherokuサイトをログイン状態で立ち上げていたから）  
⇒`Logged in as 入力したメールアドレス`と出ればOK

④もし自身のアプリのDBがpostgresqlでは無かったら、gemfileに追記が必要

⑤heroku上にアプリケーション作成  
⇒`heroku create`

```linux
Creating app... done, ⬢ aqueous-brushlands-66854
https://aqueous-brushlands-66854.herokuapp.com/ | https://git.heroku.com/aqueous-brushlands-66854.git
```

⇒`aqueous-brushlands-66854.herokuapp.com`がサブドメイン  
⇒次に基本は`git add .`と`git commit`をするのだが、ubuntuでまだgitの初期化をしていない場合は,`Please tell me who you are.`と言われるので、git configで名前とemailを設定する

```linux
git config --global user.name 自分の名前
git config --global user.email 自分のemail
```

⇒それからコミットをすると、`On branch master nothing to commit, working tree clean`とコミットするファイルが無いと言われるので、次にpushをしていく

⑤🔶重要🔶herokuへpush（🔺エラー経験あり）

※基本、コードの内容を変えたり、gemの付ける外すをやったら`git add`からやる。

★コマンドで`git push heroku master`をやると

🔺第一エラー：

```html
The Ruby version you are trying to install does not exist on this stack.
<!-- ここでherokuのstack上にrubyのバージョンが存在しない⇒今のrubyのバージョンが対応していない -->
remote:  !
remote:  !     You are trying to install ruby-2.7.0 on heroku-20.
remote:  !
remote:  !     Ruby ruby-2.7.0 is present on the following stacks:
remote:  !     <!--あなたが使っている2.7.0は下記のstackでサポートをしています -->
remote:  !     - cedar-14
remote:  !     - heroku-16
remote:  !     - heroku-18
remote:  !
remote:  !     Heroku recommends you use the latest supported Ruby version listed here:
remote:  !     https://devcenter.heroku.com/articles/ruby-support#supported-runtimes
remote:  !
remote:  !     For more information on syntax for declaring a Ruby version see:
remote:  !     https://devcenter.heroku.com/articles/ruby-versions
remote:  !
```

⇒ここで注意は、このエラーに対してrubyのバージョンを変更するという記事があるがherokuのバージョンを変更すればいいらしい。  
⇒`heroku stack:set heroku-18`コマンドを打つと変更できる（アプリプロジェクト内でやる）
⇒これでpushをしてみると

🔺第二エラー：

```linux
~~~~~~
Failed to install gems via Bundler.
~~~~~
error: failed to push some refs to 'https://git.heroku.com/aqueous-brushlands-66854.git'
```

⇒これはbundleが出来なかったことを指している。一応やった対策として

* `bundle install`(問題なし)

* `git branch`（これで現在のブランチの場所を確認して、問題なくmasterである）

* `git remote -v`(これでリモートリポジトリの一覧表示を確認)

* `heroku logs`(あとで分かったことだが、createしたアプリのherokuのoverviewを見るとbuildに失敗というメッセージがあり、エラー内容が見れる)

* 試しにもう一度createしてみたが変わらず（因みにcreateしたら再び`heroku stack:set heroku-18`で変更）

* `heroku apps`では、今あるアプリの名前一覧が見える

⇒ここまでやって解決策は`bundle update mimemagic`からのpush。実は答えが赤字では無い所に出ていた

```linux
Fetching gem metadata from https://rubygems.org/............
remote:        Your bundle is locked to mimemagic (0.3.5), but that version could not be found
remote:        in any of the sources listed in your Gemfile. If you haven't changed sources,
remote:        that means the author of mimemagic (0.3.5) has removed it. You'll need to update
remote:        your bundle to a version other than mimemagic (0.3.5) that hasn't been removed
remote:        in order to install.
```

⇒まず赤字でbundleが出来なかったと出でいるのでgemのbundleに失敗ということであり、その対象であるgemが上に出ていた。  
⇒`gem 'mini_magick'`の動かしている`mimemagic`について、`You'll need to update~`と書いてあった。これをやってから、git push heroku masterで解決

```linux
Verifying deploy... done.
To https://git.heroku.com/sheltered-taiga-84016.git
 * [new branch]      master -> master
```

⑥heroku環境におけるマイグレーション  
⇒`heroku run rails db:migrate`

⑦herokuopen
⇒`heroku open`コマンドで最初エラーと出るが、その次に書いてあるURLをコピーしてウェブ上で見る。

## heroku公開後のエラーと仕上げについて

### herokuアプリのリネーム

★🔺注意🔺：herokuホームのsettingsで変更するのではなく、ターミナルのコマンドでやった方がいい(herokuコマンドが--app 新しい名前 を付けないと動作しないようになってしまいます。)  
⇒`heroku rename 新しい名前`

### ActionMailerについて

★herokuのアプリ名を変更した場合、envファイルのHEROKU_APPNAME='willnote'と変更すること

⇒ここで詰まった点を先ず挙げる

* Googleの二段階認証が必要だった  
⇒安全性の低いアプリの設定をオンする方法ではダメらしい。自身の作ったGoogleアカウントのセキュリティにおいて二段階認証をオンにする。  
⇒普通に設定に入っていってオンにできたら、**アプリパスワード**を設定していく。その項目をクリックしてカテゴリーをその他にして適当に名前を付ける（アプリ名にしてみた[willnote]）。そしてその設定をすると次の画面に１６ケタの英語が出で来るので必ずどこかにコピぺしておく（そうするとスペースが無くなり、16文字の繋がった文字になるがそれでいい）。それをActionMailerのLOGIN_PASSWORDで使う。

* herokuホームページにおけるconfigの設定が必要  
⇒heroku createしたアプリのsettingsのConfig Varsをクリックすると環境変数を設定できるようになっている。ここに、ENVファイルで設定したLOGIN_NAMEとLOGIN_PASSWORDの中身を設定できるのでそれを入れる。  
⇒ターミナルでもできる（`heroku config:set LOGIN_NAME="ご自身のgmailアドレス" LOGIN_PASSWORD="ご自身のgmailのパスワード"`）

★以上の点を押さえて、下記のサイトを参考。  
⇒[ここが基本](https://skillhub.jp/courses/137/lessons/977)  
⇒テックピットのメール教材のherokuを使って公開するカテゴリー（herokuへの環境変数の設定）

①Googleの二段階認証をONにして、アプリパスワードを取得  
②envファイルのパスワードをアプリパスワードに差し替える（つまり、通常のパスワードは要らない）  
③新たにenvファイルにherokuで登録されたアプリ名を入れる変数を設定  
⇒heroku createした時にできた名前をenvファイルの変数に入れる（例：HEROKU_APPNAME）  
④次にconfig/productionファイルにherokuの設定
⇒`config.action_mailer.default_url_options = { host: "#{ENV['HEROKU_APPNAME']}.herokuapp.com" }`
⑤最後に、herokuホームのsettingsにあるconfigのLOGIN_PASSWORDをアプリパスワードにする
⇒`heroku config:set LOGIN_PASSWORD="アプリパスワード"`(ターミナルで打ってもよい)

```ruby
config.action_mailer.default_url_options = { host: "#{ENV['HEROKU_APPNAME']}.herokuapp.com" }
config.action_mailer.perform_caching = false
# host = "#{ENV['HEROKU_APPNAME']}.herokuapp.com"
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'gmail.com',
  user_name:            ENV['LOGIN_NAME'],
  password:             ENV['LOGIN_PASSWORD'],
  authentication:       'login',
  enable_starttls_auto: true
}
```

### adminのついたユーザーの作成について

★今回は下記のコードを新規登録項目に一時追加をして、本番で管理人を作ってから、また元に戻した

```html
<div class="form-check space mt-2">
  <%= f.label :admin, class: "form-check-label" do %>
    <%= f.check_box :admin, class: "form-check-input" %>
  <% end %>  
</div>
```

### ドラッグ＆ドロップについて

★バカ避けもしてはいるが、やはりcookieと自身の読み込み速度が低いのもあるのか、移動してページ更新すると表示がの元に戻ってしまう事があったが、一度ログアウトしたらcookieデータは保存されており、その順番になっていた。アプリ内でページ遷移したところから急にやるとそうなるみたい。

### 画像のアップロードについて

★今回の画像はherokuに上げた時点で、一定時間経つと投稿した画像が消えてしまう事に関して。herokuのリポジトリがdynoという単位で管理されており、Freeプランだと一定時間経過後にdynoが再起動される仕様になっており、再起動されるたびに保存されているファイルは消去される。  
[参考](https://tea-programming.blogspot.com/2020/03/rails6heroku_24.html)

⇒よって自身のアップする画像を、AWSのS3というストレージをアップロード先に指定することによってリポジトリの再起動の場所から外すことで解決する。

①AWSに登録をする（クレジットカードが必要で、登録時から1年無料）

②次に「S3」というサービスを使える権限を持つユーザーを登録する

⇒[awsのユーザー追加画面](https://console.aws.amazon.com/iam/home?region=us-east-2#/users)にいき、そこでユーザー追加をクリック。  
⇒ユーザー名を適当に入力（自身の名前で大丈夫）  
⇒アクセス種類を「プログラムによる～」チェックして、次のステップをクリック  
⇒ここで初めてであれば、「ユーザーをグループに追加」のパネルのままで大丈夫。グループの作成を押して、グループ名は適当（アプリ名でいいかも）。そして、検索窓に「s3」と入力して、AmazonS3FullAccessをチェックして、グループの作成して、画面戻ったら、次のステップへ(恐らく、先にグループを作成していたことがあったら、下に表示されるので、そこをチェックして次のステップでそのグループ名に追加することになる)。  
⇒タグの追加はスルーで次のステップへ、最後にユーザーの作成を押すと完了。ここの画面に出てくる`アクセスキー`と`シークレットキー`は必ずメモ  

③S3の設定[ここへ移動](https://s3.console.aws.amazon.com/s3/home?region=us-east-2)

⇒バケット作成をクリック
⇒バケット名を適当に入力（willnote：この情報は後で使う！）
⇒リージョンは、アジアパシフィック (東京)
⇒次に「このバケットのブロックパブリックアクセス設定」という項目があるので、その下の「パブリックアクセスをすべて ブロック」を外して、「新しいパブリックバケットポリシー～」「任意のパブリックバケットポリシー～」をチェックする。（つまり、アクセスコントロールと書いてある上に二つの項目はチェックされていない状態）。そして、少し下にある、🔺マークの「パブリックアクセスのブロックをすべてオフにすると～」をチェックする。
⇒あとは触らないで、バケット作成をクリックで完了。

④dotenv-railsのインストール（.envファイルのgit関連とActionMailer用に作ってあるが、一応分けるために作成することにする）

⇒gemファイルのtestとdevelopment下に`gem 'dotenv-rails'`を追加してbundle install。
⇒プロジェクト直下に`touch .env.development`コマンドでファイルを追加して、以下をコピーし入れる。

```html
AWS_ACCESS_KEY_ID=AWSで作成したAccess key ID 
AWS_SECRET_ACCESS_KEY=AWSで作成したSecret access key
AWS_DEFAULT_REGION=ap-northeast-1
AWS_BUCKET=S3で作成したバケット名
```

⇒先ほど取得したアクセスキーとシークレットキーとバケット名をこの通りに入れる。コーテションは要らない。
⇒.gitignoreファイルにアスタリスクを付けた`.env*`を追記して保存

⑤S3へ画像をアップロードするためのfog-awsというgemをインストールする

⇒gemファイルの一番下に`gem 'fog-aws'`を追加して、bundle
⇒画像投稿機能を実現するのに`carrierwave`をインストールして、uploaderファイルをappの中に作成したと思うが、`app/uploadeers/image_uploader.rb`を開いて、最初の方にある、`storage :file`をコメントアウトして、その下に`storage :fog`を追加する。
⇒ターミナルで`touch config/initializers/carrierwave.rb`を打ってファイルを追加して、そのファイルに以下をそのままコピペする。

```ruby
require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory  = ENV['AWS_BUCKET']
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_DEFAULT_REGION'],
    path_style: true
  }
end
```

⇒ここでは、先ほど取得したアクセスキーなどを参照している。

⑥あとは、この設定でローカル環境で画像登録出来るかテスト（🔺注意🔺：設定する前に投稿した画像が消しおく）
⇒大丈夫なら、最後にherokuのconfigに環境変数を設定する(コーテーションは要らない)  
⇒`heroku config:set AWS_ACCESS_KEY_ID=アクセスキー AWS_SECRET_ACCESS_KEY=シークレットキー AWS_DEFAULT_REGION=ap-northeast-1 AWS_BUCKET=バケット名`
⇒これでherokuに対して、git add. ~ git pushとmigreateをして、本番で画像投稿してみる。
⇒AWSのS3で投稿した画の記録が残っていれば恐らくこれで消えることは無い。

* メモ
⇒herokuにアプリをプッシュしている場合、そのプッシュしたターミナルでアプリをdestroyしないとアカウントを閉鎖できない
⇒
[wsl環境下ではHerokuの提案している、snapコマンドが使えません。私はsnapしようとして、対応してないと怒られました。。](https://qiita.com/RoaaaA/items/604f7538d9ef57d2f9c7)
⇒公式では、snapで書いてあるし、殆んど公式でインストールが書いてあると言っている
