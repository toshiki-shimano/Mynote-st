# willnote

★初期環境構築★  

* rails6でやるのでテックピットのやり方で導入（fontawesomeまで）

* todoの土台は、速習を基本（ｐ８２～ｐ１８２）

★準備★  
⇒rbenv（Rubyのバージョン管理）インストール  
⇒rubyのインストール、bundlerのインストール  
⇒yarnのインストール（javascriptライブラリの利用に必要なパッケージマネジャー、rails6ではwebpackerが標準になったのでyarnが必要）  
⇒railsのインストール  
⇒他エディタやターミナルの用意（vscode、Ubuntu）  

★準備②（立ち上げ）★  
⇒`rails new willnote -d postgresql`（ここではpostgreを指定。）  
（rails 6だとここでyarnを使って、webpackerとpackagejsonの構築も同時に行われる）  
⇒`cd wisbox`  
⇒次に、`sudo service postgresql start`でOKに。
⇒そのまま、`rails s`をやるとデータベースがないと出るので、、`rails db:create`と打つ
⇒`sudo -u postgres psql`と打って、きちんとデータベースに入ることができれば完了。
⇒`rails s`できちんと出れば完了！

★準備③（機能追加）★  

* webpackerを使ってbootstrapの導入
⇒webpackとは、複数のjavascriptファイルを一つにまとめて出力するwebpackをrailsに統合できるgem（rails6にはプロジェクト作成時に一緒にインストールされる）

⇒bootstrapに必要なjavascriptのプラグインも一緒にインストール  
`yarn add jquery bootstrap popper.js`を入力すると、package.jsonに追加される。

⇒次にcofig/webpack/environment.jsに以下のコードを追加

```ruby
const { environment } = require('@rails/webpacker')

module.exports = environment

  const webpack = require('webpack')
  environment.plugins.append(
    'Provide',
    new webpack.ProvidePlugin({
      $: 'jquery/src/jquery',  #ここのsrcの記入を忘れずに
      jQuery: 'jquery/src/jquery',
      Popper: ['popper.js', 'default']
    })
  )
# 上記のコードでimportやrequireなしで$やbootstrapのjavascriptが使えるようになる
```

⇒次に、app/javascript/下にstylesheetsディレクトリを作成し、そのディレクトリ内にapplication.scssを作成。  
⇒作成したapplication.scssがnode.jsから取り込んでいる大元ファイルになっており、scssファイルに`@import '~bootstrap/scss/bootstrap';`を記載。次に、そのscssファイルのパスをjavascript/packs/application.jsに記載。

```ruby
import 'bootstrap';
import '../stylesheets/application';
```

⇒最後にビューに出るようにlayoutに`<%= stylesheet_pack_tag 'application', 'data-turbolinks-track': 'reload' %>`を記載  
⇒ビューに反映されるcustom.cssを作る（stylesheetsディレクトリにcustom.scssを作る）。大元（scssファイル）に @import "custom";を記載

* javascriptディレクトリ内のimageフォルダーからcssで画像を読み取る

⇒最初に、javascript内にimagesフォルダーを作り、ダウンロードした画像を入れる、次にconfigのwebpacker.ymlのresolvedにそのパスを入れる（テックピット：２－１）

```ruby
#configのwebpacker.yml
resolved_paths: ['app/javascript/images', 'app/assets/images']
```

* ビュー内でimage_pack_tagを使ってrails6のwebpackerにおける画像の読み方
⇒[ここを参考](https://qiita.com/hida-yoshi/items/55dc48477201dc195bb8)  
⇒これを参考にjavascriptフォルダーのpacksのapplication.jsのimageのコメントアウトを外す  
⇒後は、ビューファイルにテンプレートエンジンでimage_pack_tag～と書いて、javascriptフォルダーに自分で作ったimagesフォルダーの中に画像データを入れて、ビューでパス指定無しでその画像名と拡張子を付ければ出る。画像の大きさなどを変えたい時は、コンマしてclass: を付ければcss指定できる  
(`<%= image_pack_tag "coffee.jpg", class: "test" %>`)

* fontawesomeの導入

⇒bootstrap同様にyarnを使って導入(`yarn add @fortawesome/fontawesome-free`)  
⇒大元ファイルにimportする（`@import '~@fortawesome/fontawesome-free/scss/fontawesome';`）  
⇒packsのファイルにimport(`import '@fortawesome/fontawesome-free/js/all';`)`

* jqueryの発動をapp/javascript/配下のjsファイルで発動させる方法について、、

⇒先ずpacksにあるapplication.jsの中にrequire('jquery')を記述。次にjavascriptディレクトリ内にtest.jsを作成したら、application.js内で相対パスでimport '../test.js';と読み込まないと参照されない。

## ～環境～

* Rails 6.0.3.4
* rbenv 1.1.2-34-g0843745
* ruby 2.7.0
⇒rbenv install -l で2.7.2がないのでリストにある2.7.1をインストールしたが、エラーの関係でrbenv global 2.7.0でバージョンを下げた。
（vi ~/.ruby-versionを打って、バッシュファイルは、rubyのバージョンは一応2.7.1）
* Bundler version 2.1.4
* yarn 1.22.5
* node v10.19.0（node  --versionで出る）

## ～他の追加～

1. binding.pryを使えるようにするため、gemfileに`gem 'pry-rails'`と入れてbundleし、ついでに`gem 'pry-byebug'`も入れる.  
⇒pry-railsは、binding.pryを記述してデバッグできる  
⇒pry-byebugは、binding.pryで止めた所から、nextコマンドなどが使える。（使うには、`require 'pry'`を記述する）  
⇒開発とテスト環境どちらでも使うため、group :development, :test doに入れる。  

2. ビューでリンクがリンクとして認識されるように、gem "rails-autolink"も付ける（p180）

3. railsのエラーを日本語で出るように、ターミナルで（アプリケーション下で）  
⇒`wget https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml -P config/locales/`  
⇒を打つと、**config/locales/ja.ymlファイル**に一式がセーブされる。次に、config/initializersの中にlocale.rbというファイルを作成して、そこに
⇒`Rails.application.config.i18n.default_locale = :ja`を記述。  
⇒モデルが作成され、そのデータの表記を日本語化する時は、config/locales/ja.ymlの中のerrorsと同じ真下にmodelsを記述。インデントして小文字でモデル名を書いて、attributesをmodels直下に書いてから始まる。（速習ｐ１０１。必ずerrors:の直下にmodelsを置くこと。attributes:の後のモデル名を書いたら、次のカラムはインデントすること)  
⇒configのja.ymlにはerrorsメソッドがあり、モデルを作らないsessionなどは、ymlに記載がないのでerrorsメソッドが使えない。コントローラーでalertを設定して、bootstrapのalertをviewに使う

4. config/application.rbのmoduleの中に、

```ruby
config.time_zone = 'Tokyo'
config.active_record.default_timezone = :local
```

⇒追記すると、created_atやupdate_atの時間が日本時間に変わる  

🔺注意🔺
◍layoutのyieldをcontainerで囲むと別のビューをいちいち囲まなくて済むが、ナビバーはこの効果は要らないので、やはりそれぞれのビューにきちんと付ける。
⇒containerが無いと、全ての要素がデフォルトで画面一杯まで広がってしまうので基本はあった方がいい。また、container配下では無いと使えないタグや属性もある。  
🔺よってlayoutビューにエラーメッセージが出現するコードを書いてしまうとエラーメッセージがナビバーの上に出てしまうので、ナビバーrenderの下にnotice用のパーシャルがいる。よって、、、  パーシャルファイルを作り、そこに一番上にナビバー用のコード。その下にnotice出現用のコードを書けばファイルは１つで済む。

* createアクションなどのredirect_toのnoticeが全てのページで使えるようにlayoutファイルにフラッシュが出るように記述もできる（速習ｐ１０９）

```ruby
①redirect_to notes_path, notice: "タスク#{@note.name}を登録しました"

②flash[:notice] = "タスク#{@note.name}を登録しました"
 redirect_to notes_path
# ①と②は同じ意味でflashに渡せるキーは:noticeか:alertのどっちかである
③flash.now[:alert]
#画面が移る前に表示？
```

```html
<!-- noticeの表示のためにはビューの方にも記述が必要 -->
<% if flash.notice.present? %>
    <div class="alert alert-success" id="flashMessage">
      <%= flash.notice %>
    </div>
<% end %>

```

* editやnewページで更新保存した時にエラーメッセージが出るようにする。（p140）  
⇒下記のは、確かテックピット式

```html
<% if @note.errors.any? %>
      <div class="alert alert-danger" role="alert">
        <strong>入力内容にエラーがあります</strong>
        <ul>
          <% @note.errors.full_messages.each do |msg| %>
           <li><%= msg %></li>
          <% end %> 
        </ul>
      </div>
  <% end %>
<!-- こっちはユーザーが入力する画面のファイルに記述し、検証が引っかかれば表示されるようにする（modelがあるデータ） -->
```

## ToDo機能の作成

★notesテーブル（Noteモデル）

* name(string型 null無し デフォ無し)

* memo1(text型)

* memo2(text型)

🔺最初からアソシエするなら

* user(references型  null無し)
⇒user_idとインデックスの自動追加

★usersテーブル（Userモデル）

* name(string型 null無し デフォ無し)

* email(string型 ユニークtrue、null無し デフォ無し)

* password_digest(string型)
⇒passwordとpassword_confirmation

🔺後で追加

* admin追加（boolean  null無し）  
⇒password_digestとhas_secureでpasswordとconfirmation属性が出来る  
⇒idと更新日時はrailsが自動的に用意してくれる  

①modelを作成（Noteモデルの作成によりnotesテーブルを作成）

⇒追加カラムは、name、memo1、memo2  
⇒`rails g model Note name:string memo1:text memo2:text`  
⇒ER図に沿い、中身を設定してmigrate  
⇒Noteモデルに検証、nameにpresenceとlength  

②notesコントローラーを作成  
⇒`rails g controller notes index show new edit`  
⇒ルーティングは`resources :notes`と`root "notes#index"`  
⇒各アクションの記述（入力された値はparamsで受け取る）

* newアクション：`@note = Note.new`でインスタンス（容器を作っておく）

* indexアクション：`@notes = Note.all`は複数形で`s`をつける

* showアクション：idでモデルオブジェクトのレコードをデータベースから検索。idで検索するのでfindで良い。
⇒詳細に表示するデータを引っ張るときに.allの他にもfindと`params[:id]`を使うことでそのデータを引き出せる

* editとupdateアクションはセット（newとcreateと同じような関係）
⇒editアクションでデータを取得（`@note = Note.find(params[:id])`）
⇒updateアクションでは、データを取得しなおして、updateメソッドを使う

③viewの編集  
⇒Noteモデル用のymlファイルを編集（ｐ１０１）

* newアクション用のビューはform_withで作る  
⇒form_withメソッドの引数に@note（このインスタンスを使う）、classにform-groupとform-controlを使用。

* indexアクション用のビュー  
⇒`@notes = Note.all`で登録されたデータをtableタグと@notesで表示できるようにする
⇒i18nを設定していると`Model.human_attribute_name(attribute) メソッド`を使うことで、モデル名と属性名を透過的に参照できるようになる。
（`<th><%= Note.human_attribute_name(:name) %></th>`）
⇒ここに記述する編集ビューへのリンクは、ブロック変数が無いとルーティングエラーになる。おそらく、編集するにはその編集するためのデータがどのidかという特定が必要だから、link_toの後のパスに（）で引数が必要。つまり、そのidを持ってそのパスをリクエストする。（引数がないとどの詳細ページか特定できない）
（showにおけるlink_toのパスはブロック変数を使ってないから引数は要らない。各idごとの専用のページへのリンクは引数が必要。その専用ページに入ってからのリンクは、同じデータの編集などする時にはすでにidを取得した状態だから引数が要らない）

⇒データベースを引っ張りたいtbodyはeach～end文で挟み、そこに@noteを使う（`<% @notes.each do |note| %>`）。mbはmargin-bottomの略。

⇒名称をshowへのリンクに変える箇所（`<%= note.name%>を<%= link_to note.name, note_path(note) %>に変える所`）では、link_toのキャプチャの部分をeach文のブロック変数のnameをそのまま使う

* showアクション用のビュー  
⇒showページでは既にあるデータをfindで引っ張り、@noteに入れて、ビューの@note.nameといった形で引きせるようにする。

⇒urlリクエストで"notes/1"の１というidを付けたパスをリクエストし、その１をparams[:id]の[:id]に入れ、それを元にfindで検索をする。つまり、showページは、notes/1とかnotes/2などそれぞれページが存在し、そのidへのリクエストがあれば、コントローラーでparams形式でそのidを受け取り、そのページを表示するという命令になっている。

⇒つまり、作成するときは、.newの命令。既にあるデータを表示するには、find(params[:id])。idを引っ張るだけでそのデータ全体が得られる。params[:name]ではどのnameかわからない（idで引っ張ると一意のデータを取得できる）  
⇒showページではデータの取得については、each~endを使わずそのまま取得している。  
⇒showのビューページの`<td><%= simple_format(h(@note.memo1), {}, sanitize: false, wrapper_tag: "div") %></td>`については、P113の説明がわかりやすい。（memoに多くの文章や改行が入ることを想定して、型崩れしないようにするrailsのメソッド）

④編集ページとリンクとupdateとパーシャル

⇒showと同じく元々あるデータから引っ張るから、find(params[:id])を使う。  
⇒newビューの状態をそのまま更新するのだから、newと同じコードになり、newとeditのコードはパーシャルする。  
（editビューはnewと違ってfindでデータを取得するから、ページのフォームには値が入っている。）

⇒パーシャルの関係上、submitのキャプチャはnilに、囲んでいるクラスの名前は揃える（notenewPageをnotePageに）  
（`<%= render "partialnote/form" %>`）

④redirect_toへのフラッシュメッセージ（p107）  
⇒createのsubmitはi18より、キャプチャのところをnilにするとそのまま名前を入れてくれるのでnilにする。  
⇒フラッシュメッセージも編集の更新(update)と新規登録の保存(create)で共通で使うので、フラッシュメッセージが表示される先のファイル、つまり編集してアップデートをした先のroot_pathに行くので、indexビューファイルの一番上の行にrenderパーシャルを置いて上に表示されるようにする。  

```html
<% if flash.notice.present? %>
    <div class="alert alert-success" id="flashMessage">
      <%= flash.notice %>
    </div>
<% end %>
<script>
'use strict'
$(function(){
  $("#flashMessage").fadeOut(5000);
});
</script>
```

⑤deleteの実装(テックピットを基本に)

* ルーティングでresourcesをしているのでルーティングはOK。コントローラーにdestroアクションを記載。

⇒`<%= link_to "削除", note, class: "btn btn-danger", method: :delete, data: {confirm: "#{note.name}を削除してよろしいですか？"} %>`の部分で、link_toのパスの部分はなくても大丈夫みたいだが、基本上にあるeachのブロック変数を持ってくる。また、編集と削除ボタンをくっつけるためにも、それぞれを`<td>`タグで挟むのではなく一緒にまとめて挟む。上の`<th>`タグの数とも数が揃う。注意は、showのページに同じdeleteリンクを入れる時、式展開はnoteではなく、@noteに変更する（indexでは、each文のブロック変数をそのまま使っていたのでnoteだけでもよかった。）

⑥モデルに検証（バリデーション）をかけて、エラーメッセージが表示されるようにする（p140）

⇒マイグレファイルでnameカラムを`null: false`にして、Noteモデルファイルでnameカラムに`presence:  true`をかけるが、これだけだと未入力の時にエラーが表示されない。したがって、その表示が欲しいeditとnewのビューファイルの**上に**コードを書く。（入力してその場でエラーメッセージが出てほしいビューの上に付ける〔ただし、ナビバーの下〕）これらは同じコードなので、パーシャルする。〔`_form.html.erb`〕（テキストにはslimで書いてあるが、#はid=、- は<%になる。作ってある@noteオブジェクトにerrors.present?で検証エラーの有無を調べ、あればif文実行。ja.ymlのメッセージが出る）

⑦ログイン機能：ユーザーモデル作成（p149）  
⇒ここでやりたいことは、登録したユーザーがそのnoteデータを持っているという形

★railsでは、コントローラーからsessionというメソッドを呼び出すことで、セッションにアクセスできる。cookiesに含まれるIDをセッションidとしてブラウザ側で保存、同じドメインにリクエストする時にも送り、サーバー側もそれを受け取ってそれの情報に紐づいたデータを出力。

* セッションにデータを入れる

⇒Userモデルのidを入れるには、`session[:user_id] = @user.id`  
⇒値を取り出すには、`@user.id = session[:user_id]`（Useモデルのオブジェクトからidを呼び出して入れている。）

⇒先ず、モデルを作る(`rails g model User name:string email:string password_digest:string`)  
⇒マイグレでemailのユニークの記述の仕方については、後ろにそのまま書くのではなくindexという型を設けて改めて記述する必要があるのかも。もちろん、Userモデルのnameとemailにも検証をかけておく（presence: true）

* password_digestカラム作成される

* Userモデルに`has_secure_password`設定  
⇒データベースにpasswordとpassword_confirmation属性が追加される

* `gem bcrypt`(コメントアウトをはずす)  
⇒bundle忘れずに

* 次に、usersテーブルにadminというカラムを追加するために  
⇒`rails g migration add_admin_to_users`（マイグレファイルを追加）

⇒`add_column :users, :admin, :boolean, default: false, null: false`（usersテーブルにadminというカラムをboolean型で追加）

⑧新規登録画面に向けて

⇒ユーザー管理はadminがtrueになっているユーザーだけが見れるように実装する

⇒普通にユーザーデータを作成する時にコンソールでadmin属性を付けて、他は新規登録で作る。まず、ユーザーが新規登録しないとログインできないようにする。

★セッション機能を使った新規登録を行うとセッションにモデルが必要になってしまうので、新規登録はusersコントローラーでつくる

⇒先ず、usersコントローラーを作る。`rails g controller users index new edit`  
(indexアクションは、管理者がユーザー一覧を見えて退会させられる。editアクションは、自身の名前とアドレスを変えられる）

⇒ルーティングは必要なアクションをresourcesする。新規登録のnewアクションだけはログインに絡むので、名前をregistrationに設定。

```ruby
get "/registration", to: "users#new"
resources :users, only: %i(index create destroy edit update)
```

⇒destroyアクションのリダイレクト先は、ユーザー一覧に戻るで設定。createのリダイレクトは後のログイン画面に飛ぶようにする。

⇒先ずnewビューをform_withを使って記述してDBに保存できる形をつくり、indexを作って表示させる。その中に削除ボタンを作る。

⇒destroyアクションのパスは、そのままユーザー一覧に残ってくれていいので、users_pathでindexページを表示させる
（admin表示はデフォルトで無しにしているので後でコンソールで追加する）

🔺注意

●`<User id: 1, name: "島野俊希", email: "slimslim@au.com", password_digest: [FILTERED], created_at: "2020-12-02 04:25:34", updated_at: "2020-12-02 04:25:34", admin: false>`と、このようにユーザー一覧で上に出てしまう（モデルの中身が出てしまう件は、、）  
⇒<https://qiita.com/superman9387/items/988fc11118a0f0c159fc>

⑨ログイン機能（sessionコントローラー（認証機能を作る）ｐ１６１）

★**sessionのルーティングについて、なぜかresourcesだとルーティングエラーになってしまうのでそれぞれルートを作る**
（ログインホーム（get:new）、ログインする（post:create）、ログアウト（delete:destroy）の実装）

⇒コントローラーを作り`rails g controller sessions new`(newはログイン画面)、ルート設定で必要なアクションの記述（P162）

```ruby
get "/login", to: "sessions#new"
post "/login", to: "sessions#create"
delete "/logout", to: "sessions#destroy"
```

⇒コントローラーはdef newだけ書いてあれば表示されるので、先ずnewページ作成。今回は、form_withの引数にscopeを使用、モデルが無いためymlに書いても適応されないので、labelの後ろに直接の日本語を明記。

⇒次に、入力されたemailとパスワードを使ったログインをするが、ユーザーやタスクの新規登録の役割が違う（DBにただ保存をするわけではない:P164）

```ruby
def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "ログインに成功しました"
    else
      render action: :new
    end
  end
```

⇒まず、ストロングパラメーターでemailとpasswordしか受け付けないようにする。find_byで入力されたemailの値をparamsで受け取り、同じemailのユーザーをUserモデルから探す。そのモデルから検索したユーザーが持つパスワードが、入力されたパスワードと一致するか（authenticateメソッド、ボッチ演算でnilのエラー防ぎ）確認して、if文がtrueなら、そのユーザーのidをセッションのidに格納（Evernoteの⑦にあり）

★authenticateメソッドは`has_secure_password`を記述すると使えるメソッド。ユーザーがいない時は、nilになるのでボッチ演算子でエラーにならないようにする。つまり、ログイン状態というのは、`session[:user_id]`に`id`が入っているかどうか否かで実現している。これがログインしているの意味、裏を返せばidが入ってないという事は、ログインしてないということ。これで、session[:id]という属性を使って、消したり、見えなくしたり、表示されないようにしたり、idがnilならログインできないようにしたりできる

★idで検索するならfindでも良さそうだが、、

* `find(session[:find])`でもユーザーを取得できるが、findメソッドはnilを渡すとエラーになる（つまり、セッションが途中で消えてしまうエラーが出てしまう。セッションはアプリの設定によって時間が経ったり、ブラウザを閉じると切れてしまうのものがある。）

＝＝上記をうけて＝＝（🔶重要🔶）

1. applicationコントローラーにこのidを用いたオリジナルメソッドを定義して全コントローラーで使えるようにする

2. さらに作成したメソッドを同じアプリケーションコントローラー内のprivate外にヘルパーメソッドとして記述して全てのビューで使えるようにする

⇒セッションidを使い、current_userメソッドをつくる

```ruby
  #app/controllers/application_controller.rb
  helper_method :current_user

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  #idだけではなくそのidを使ってそのユーザー全体の情報をを取得
```

⇒@current_userという変数に何かが入っているならそのまま、入ってないなら、find_byで見つけて入れる（ifの後ろはsession[:id]にidがあれば）これで、セッションidを維持できるようになる。ログアウトでは、current_userメソッドが全コントローラーで使えるので、destroyで使う。ただし、session.delete(:user_id)だけだとユーザーに紐づく情報までは消せないので、railsにある**reset_session**というメソッドを使う。重要なのは、これらのメソッドを使ってコントローラーのdestroyにどのような指示を書くか？（何をdestroyするのか⇒session[:id]をnilにする。ログアウトしたら、ログインページへ飛ぶのが普通なので、リダイレクト先はログインページ）

```ruby
def destroy
    reset_session
    redirect_to login_path, notice: "ログアウトしました。"
end
```

⑨ビゲーションバーの実装とルーティングの整理（current_userをどう使うか）

* 上に共通のナビバーを作る。記述場所は、レイアウトビューファイルではなくパーシャルファイルに作成。（レイアウトビューに書くと後に管理人用のナビバーと差別化出来なくなる）  
⇒navタグではさみ、そのタグにnavクラスをつける。ulタグにもnavbarクラスを付けて,特にml-autoが重要！（**記録残しのbootstrapの所参考**⇒`navbar-expand-md`はbootstapでnavbarクラスを使うのに絶対に使う）

⇒ナビバーは、ログインしていないとログイン中のナビバー機能を使えないようにするために、current_userのif文で分岐させ、セッションidが入っていれば表示する、入っていなければ表示しないを書く。link_toのパスは、notes_pathといったヘルパーパスを使う。そして、そこにログアウトも入れる。

* `"#{current_user.name}さん"`は、curret_userが使えるなら出来るレイアウト。ログイン中のみの表示にしたいので、if文のcurrent_userの下のナビに添える。ただし、レイアウトをそろえるためにclassをnav-itemにすること！

```html
<nav class="navbar navbar-expand-md navbar-light">
      <div class="navbar-brand">Willnote</div>
      <ul class="navbar-nav ml-auto">
        <% if current_user %>
          <li class="nav-item"><%= link_to "#{current_user.name}さん", edit_user_path(current_user), class: "nav-link" %></li>
          <li class="nav-item"><%= link_to "ノート一覧", notes_path, class: "nav-link" %></li>
          <% if current_user.admin? %>
            <li class="nav-item"><%= link_to "ユーザー一覧", users_path, class: "nav-link" %></li>
          <% end %> 
          <li class="nav-item"><%= link_to "管理人ブログ", adminhome_path, class: "nav-link" %></li>
          <li class="nav-item"><%= link_to "ログアウト", logout_path, method: :delete, class: "nav-link" %></li>
        <% else %>
          <li class="nav-item"><%= link_to "ログイン", login_path, class: "nav-link" %></li>
        <% end %>
      </ul>
</nav>

<% if flash.notice.present? %>
    <div class="alert alert-success" id="flashMessage">
      <%= flash.notice %>
    </div>
<% end %>
<script>
'use strict'
$(function(){
  $("#flashMessage").fadeOut(5000);
});
</script>  
```

⑩ログインしないとtodo機能が使えない設定（before_actionコントローラーの**フィルタの設定**)

★ログインしないとnoteページは入れないけど、userビューの新規登録画面はいけるようにする。そのためのlinkを貼る

⇒「ログインしていないと」という制約を実装するには、一つ考え方でコントローラーのアクションを起こす前に共通コントローラーでbefofeをかけるという手がある。テキストでは、共通コントローラーに記述していたが、今回usersコントローラーの新規登録は制約はかけたくない為、それぞれのコントローラーにbeforeとそのメソッドの制約をonlyを使って記述。（usersのnewとcreateは新規登録だから制約をかけない）

```ruby
before_action :login_required
~~~~~~~
private

def login_required #カレントユーザーがtrueではない（ログインしていない）ユーザーは強制でログイン画面へ
    redirect_to login_path unless current_user
end
```

⇒これをusersコントローラーの一番上にbeforeでかける

* notesコントローラーは全てかける。（session[:id]に値が入ればリダイレクトしない）

* usersコントローラーは、indexとdestroyのみフィルタをかける（newとcreateは新規登録させなきゃいけないから）

* sessionsコントローラーは、かけない（ログイン画面の表示もログアウトの表示や命令もログイン前）

⇒他の画面に飛ばない確認ができたら、ログイン画面に新規登録のリンクを貼る（見栄えを考え、btn btnとmb-4の調整とawesome使用する。）

⑪アソシエーション（ｐ１６９ではここでマイグレにreferences型を追加している）

★ログインしているユーザーにそのユーザー自身のタスクデータだけを管理できるようにさせたい  
⇒UserモデルとTaskを紐づける。具体的には、notesテーブルにuser_idカラムを付加する

★テックピットでもあったストロングパラメーターのmergeはやらない。こっちでは、createする時にcurrent_user.notesでuser_idを拾っている。

🔺注意🔺
⇒ここで追加するぐらいならrollbackしてreferencesを追加しようと思ったが、マイグレをロールバックしてreferences型を加えた後migrateすると、userテーブルが無いと言われる。これは、usersテーブルより先にnotesテーブルを作っているからであり、migrateの順番を変えて先にuserのファイルをやるという手もあるらしいが、それはあくまでローカル環境のみで、本番環境では日付順でmigrateするらしい。結果、先にnotesテーブルを作ってしまったので、add~toでreferences型を追加する方が賢明である。ということで、references型を追加する。

⇒rails g migration AddUserIdToNotes（マイグレファイルのexecuteは一度そのモデルのデータを消す。先にuser_idが入ってないデータがあるのでそれを消さないといけない。後で、コンソールでNote.allで調べてみると確かに全て消えている。）

```ruby
class AddUserIdToNotes < ActiveRecord::Migration[6.0]
  def up
    execute 'DELETE FROM notes;' #SQL構文だからシングルコーテーション
    add_reference :notes, :user, null: false, index: true
  end
  
  def down
    remove_reference :notes, :user, index: true
  end
end
#既存のテーブルにreferences型を追加ということでnotesテーブルにUserモデルに紐づくuser_idを追加し、indexもつける。ただ、foreign_keyは使ってない
```

⇒次にNoteモデルに`belongs_to: user`  Userモデルに`has_many :notes, dependent: :destroy`を追加

🔶重要🔶

⇒ここでこの定義をすることにより、以下のメソッドが使えるようになる。

* user.notes  
（Userクラスのインスタンスから紐づいたNoteオブジェクト一覧を得られる。これは、ログイン状態でcurrent_userメソッドがtrueな時は、current_user.notesでも得られる！user.notesと同じことになる）

* note.user(タスクにおいてユーザーは一人しかいないから単数形？NoteクラスのインスタンスからUserオブジェクトを得られる)

* noteのインデックスにnote.allだと全てのユーザーのタスクがでてしまうが、@notes = current_user.notesで`今ログイン中のユーザーのオブジェクトを！`という指定ができる

* 因みにテックピットでは、user_idに対してコントローラーでmergeを使った時は、アソシエとreferencesを設定してuser_idがnullがfalseで設定するとそのuser_idが入ってないと登録できない。`merge(user: current_user)`をストロングパラメーターに追記しないといけない。つまり、これからのデータがuser_idが入ったデータじゃないとエラーになるので、createやupdate時にcurrent_userなどを使ってデータを作成しないといけない。

★アソシエーションのよるリファクタリング（ｐ１７２）

⇒テックピットだとコントローラーのストロングパラメーターでmergeを使ってuser_idを入れていただけ。これでもいいが、他のユーザーがurlに他のidを打ってそれがヒットしてしまった場合には、そのページが出てしまう（User.allなど）。よって、そのページをコントローラーでcurrent_userを付与してそのタスクを作ったり（new、create）、表示したり（index）、検索したり（edit、update、destroy、show）すると、そのユーザーのタスクだけを扱うシステムにできる。

⇒よって、コントローラーのそれぞれのアクションをcurrent_userとアソシエを使って表記する。  
(referencesでuser_idが入ってないnoteデータはnullがfalseになっているので途中で追加する場合、db:resetするかexecuteをする。そして、コントローラーにuser_idを入れるためのコードを記述しなくてはいけない。newは変更なし。)

* create  
⇒@note = current_user.notes.new(note_params)  
(テックピットはストロングパラメーターにmergeを、速習でこのcreateにmergeを記述する方法も紹介があるが、ここではアソシエーションメソッドを使う。ここで、ただのnoteデータを作るのではなく、今ログインしているcurrent_userを巻き込んでuser_idを一緒に登録する。)

* index  
⇒`@notes = current_user.notes`  
（Note.allだと全てのユーザーのnoteデータが出てしまうのでcurrent_userで検索する）

* show,edit,update,destroy  
⇒`@note = current_user.notes.find(:params[:id])`  
（Note.find(params[:id])だけだとid検索をして他のユーザーにidがヒットしてしまう可能性があるので、current_userのみ検索出来るようにする）

* ここでは、show,edit,update,destroyと最初の行に同じコードがあるのでbefore_actionでリファクタリングする。

```ruby
#notesコントローラー
before_action :set_note, only: %i(show edit update destroy)


private

def set_note #情報の取得をカレントユーザーに限定する
    @note = current_user.notes.find(params[:id])
end
```

* usersコントローラーのbefore_actionに.admin?を付け足して、ユーザー管理一覧はadminしか見られないようにする

```ruby
#usersコントローラー
before_action :required_admin, only: %i(edit update)

private

def required_admin
    redirect_to root_path unless current_user.admin?
end

def login_required #カレントユーザーがtrueではない（ログインしていない）ユーザーは強制でログイン画面へ
    redirect_to login_path unless current_user
end
```

⑪仕上げ追加

* ナビバーのユーザー一覧をif current_user.adminで挟む

* ユーザーの削除や一覧表示はadminのみにする。今回の新規登録は（userコントローラーのnew,create）一般ユーザーもOKなので、index(一覧)とdestroy（ユーザー削除）のみに追加でbefore_actionとそのメソッドにadmin？を付ける。そうすると、今adminユーザーが居ないので、コンソールで作る。
(`User.new(name: "admin",  email: "slimslim@au.com", admin: true, password: "aaabbb", password_confirmation: "aaabbb"`)

* あとは、一応noteデータの表示順を安定させる為に、noteコントローラーのindexアクションにorderを付ける（つけないと表示が不安定になるらしい）
⇒`@notes = current_user.notes.order(created_at: :desc)`

* ユーザーの名前とアドレス変更は、出来るようにしておく
  
①ルーティングのusersにeditとupdate付与  
②usersコントローラーのedit、update編集（updateメソッドは途中引数が必要）
⇒`if @user.update(user_params)`これは基本で、updateをする時にストロングパラメータを付けてあげる。
⇒これはadminだけではなく一般ユーザー出来るようにするのでrequired_adminはeditとupdataには設けない。データの引っ張りはアソシエのcurrent_userは使わなくていいと思う

```ruby
def edit #adminも一般ユーザーも変更可
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_path, notice: "プロフィールを変更しました"
    else
      flash.now[:alert] = "変更に失敗しました"
      render action: :edit  
    end
  end
end
```

③usersビューファイルで新たにeditビューを作り、newビューのパスワード以外のコードをコピーし、そのファイルのタグのクラス名をちゃんと変える（userProfilePage）

④ナビバーの名前をクリックすると飛べるようにしたいのでlink_toを～さんの所へ  
⇒🔺注意🔺：link_toのパスを普通にedit_user_pathだけにするとno match routeと出てしまう。パスの引数に（curren_user）を付けるとOKだった。link_toを貼る前にurlに直接接続したときに/users/1/editと入ったが、おそらくedit_pathだけでは1の部分が取得できなかった為と思われるので、引数を付けたらうまくいったのはそういうことかもしれない。

## javascript導入

★まず、[jqueryの導入](https://techtechmedia.com/jquery-webpacker-rails/)で設定  
（この通りにやって検証のconsoleにok出た！最初のwebpackの所はちょっと中身が違うがそのままでok）

⇒本で基礎固め(rails6での開発を軸とする)

* 『javascript超入門』

* 『javascriptレシピ集』の基礎ｐ２０８まで

### 管理人ブログの作成(投稿機能)

①準備、初期設定

⇒最初に、javascript内にimagesフォルダーを作り、ダウンロードした画像を入れる、次にconfigのwebpacker.ymlのresolvedにそのパスを入れる（テックピット：２－１）
⇒`resolved_paths: ['app/javascript/images', 'app/assets/images']`  
(ここにassetsも入っているから、そこに作っても設定できそう)

⇒~~管理者用のナビバーは必要ないかも。ヘッダーがあり、ドロアーがあれば中身は投稿機能でいいので、テックピットは最初のimagesの処理以外は実際は５－１からで良い。~~  
⇒ユーザーテーブルはすでにあるので今度はテーブル設計でreferences型を使える。

★postsテーブル（Postモデル）

* caption(string型)

* user_id(references型 null無し)

★photosテーブル（Photoモデル）

* image(string型 null無し)

* post_id(references型 null無し)

* 検証：validates :image, presence: true

⇒モデル作成、ER図通りに設定して、migrate。UserモデルにPostモデルへのアソシエ。PostモデルとPhotoモデルのアソシエ（has_manyのdependent: :destroyを忘れずに）

★carrierwaveとMinimagickの導入(🔶重要🔶)
⇒ここを先に確認！[carrierwaveの使い方](https://qiita.com/Inp/items/cc447237e23bf10d159e)

①gem 'carrierwave', '~> 2.0'を追加して、bundle installをやるとminimagickも一緒に追加された？

②先ほど作成した、imageカラムに紐づくuploaderを作成：`rails g uploader image`  
（ここでappの中にImageUploaderファイルができるので覚えておく。）

③次に、PhotoモデルのimageカラムにImageUploader（先ほどapp内に出来ファイル）を紐づけ
⇒`mount_uploader :image, ImageUploader`

★Minimagickを使うためには、imageMagickをOSに（環境に）インストールしなくてはいけない。

⇒環境にインストールするという事は、自分の場合Linuxのubuntuを使っているので、windowsにインストールするというよりも環境であるubuntuにインストールする。よって、ubuntuでのインストール方法でやる。いきなり、sudo apt install imagemagickをやるとエラーになる。（最初のインストールに時間がかかる１５分くらい）

⇒まず、`sudo apt-get update`。次に、`sudo apt install imagemagick`。そして、インストールされているか確認。`convert -version`

⇒これで`Version: ImageMagick 6.9.10-23 Q16 x86_64 20190101 https://imagemagick.org`と出てくればOK！先ほどMini_magickが一緒にインストールされていたが、一応、gemにmini_magickを追加して、bundle install。

⇒`app/uploaders/image_uploader.rb`を修正する（５－２）

* 4行目のすでに生成されているコードのコメントを外す(include CarrierWave::MiniMagick)

* 「version :medium」というサイズを指定するコードを追加

```ruby
#   process resize_to_fit: [50, 50]
# end
# とある真下に追加
version :medium do
    process resize_to_fill: [1080, 1080]
end
#mediumというバージョンが作成され、画像を1080 x 1080ピクセルにリサイズする。
```
  
* extension_whitelistメソッドのコメントアウトを外す

②投稿機能のページ（postとphoto）

★ここからの流れ

⇒ここでは画像データの保存ということで、postデータをcreateする時にインスタンスを作成し、同時にそのインスタンスに画像も保存するという流れになるので、関連付けをした後、コントローラーのnewでは、postデータの取得と同時にphotoのデータの取得。createでは、postを保存すると同時にphotoのimageデータを入れる処理。viewには、photoデータを持ってくる処理を記載する。（postsはnewとcreateのみ、photoはcreateのみのアクションを作る）

⇒ルーティングでは、urlにpostの所有するidを含めてphotoにアクションを渡すために、ネストするか、`post '/posts/:post_id/photos',  to: 'photo#create', as: 'post_photos'`と全て記載し、asで名前も変更していく方法があるが、**ネストがわかりやすいのでその方法をとる。ネストするとルーティングを見ると、ちゃんとurlにpost_idが挟まっている。**

```ruby
resources :posts, only: %i(new create) do
    resources :photos, only: %i(create)
end
```  

⇒postsコントローラー作成（`rails g controller posts`)とコントローラーの編集（new  creare  ストロングパラメーター）

* newアクションでは、関連付けの慣習でプラスで@post.photos.buildを付ける。buildはnewと同じくインスタンスを作り、関連付けした時に付ける。

```ruby
   def new
     @post = Post.new 
     @post.photos.build #postとphotoの関連付けにより記載。
   end

   def create
     @post = current_user.posts.new(post_params)
     if @post.photos.present?
        @post.save
        redirect_to posts_path, notice: "投稿が保存されました"
     else
        flash.now[:alert] = "投稿に失敗しました" 
        render action: :new   
     end
   end

private

   def post_params
      params.require(:post).permit(:caption, photos_attributes: [:image])
   end
```

* ストロングパラメーターは、createアクションの.newでcurrent_userを付けて追加する。今回postとphotoを同時に保存していくという流れで、photosテーブルのimageもpermitに含めるため、`photos_attributes: [:image]`という記載も入れる。

⇒createは、ifの後にすぐsaveではなく、@postにphotosデータが入ったかどうかの確認を入れる。(`@post.photos.present?`)

* 🔶重要🔶：postとphotoのもう一つ関連付け（accepts_nested_attributes_for）

⇒`accepts_nested_attributes_for`は、親子関係のある関連モデル(今回でいうとPostモデルとPhotoモデル）で、親から子を作成したり保存するときに使う。今回投稿する際にPostモデルの子にであるPhotoモデルを通して、photosテーブルに写真を保存するので、`accepts_nested_attributes_forメソッド`を親のモデル（Postモデル）に追加する必要がある。

* postnewビューファイルの作成

⇒ビューファイルでfields_forを使うことで、子モデル（今回でいうとPhotoモデル）に変更を加えることができる。投稿の画像は、postsテーブルではなくphotosテーブルに保存する。その際はpostnewビューでは fields_for を使うためには、コントローラーには`photos_attributes`を追記（ストロングパラメーター）モデルには、`accepts_nested_attributes_for` を記載する必要がある。（postを使ってphotoにデータを入れる流れ）

```html
<%= form_with model: @post, class: "upload-images p-0 border-0" do |f| %>
  <div class="form-group row mt-2">
    <div class="col ml-0"> <%# md-の調整で長さ、marginの方が調整効く %>
      <%= f.text_field :caption, class: "form-control border-1", autofocus: true, placeholderル入力" %>
    </div>
  </div>
  <div class="mt-4">
    <%= f.fields_for :photos do |i| %>
      <%= i.file_field :image %>
    <% end %>
  </div>
  <div class="text-center mt-5">
    <%= f.submit "投稿する", class: "btn btn-info" %>
  </div>
 <% end %>
```

⇒出来たら、保存できるか確認をして、コンソールでuser_idが入っているか確認。gifはかなり重い（重すぎると保存できないかも）

* gitにおけるオプションあり  
⇒githubでコードを管理している場合、今のままだと、画像をアップロードする度に画像がコミット対象になるので、gitignoreファイルに以下のコードを追加してアップロードした画像はコミットしないようにする。
(`public/uploads/`)

③投稿ページを表示させる

⇒次にルーティングのpostsにindexを増やし、コントローラーでindexアクションを作る。変数は複数形（@posts）、さらに、n+1問題関連でdiffで検索数が減っていたので一応includedsを挟む。管理者のみならやる必要が無いかもしれないが今後の課題。

🔶重要🔶
⇒今回は、管理者のみの投稿なので、Postに対して.allでも問題はない。これが、それぞれのユーザーの投稿を出すのであれば、n+1問題や表示方法を考えなくてはいけない。

★indexビューを作成

⇒ここではcarrierwaveとMinimagickで導入したアップローダーがimageカラムに紐づいているので、その仕様が適応される。

```html
<!-- 基本的な画像の表示はviewにimage_tag user.image.to_sで表示させる -->
<% @users.each do |user| %>
      <tr>
        <td><%= image_tag user.image.to_s %></td>
      </tr>
<% end %>
```

⇒ここでimageの後を.to_sにすると、それぞれの画像の大きさで投稿画像が表示されるのでto_sはしていない。また、アップローダーのmeidum機能を使うとそれぞれの画像をその一定の大きさで表示してくれる。アップローダーファイルのmedium~do~の（）内の数字は、画像が投稿された（保存された）時に効果があり、（300, 300なら）このサイズでリサイズされ保存されるので、表示画面が広いと画像も荒くなる。つまり、（1080, 1080）ならこのサイズで保存される。後は、さらにこれに加えcontainerやcssクラスといった画面の幅や高さとの調整になる。

```html
<div class="card-body">
  <%= link_to(post_path(post)) do %> <%# 画像をcard-bodyに入れることで取り込む%>
   <%= image_tag post.photos.first.image.url(:medium), class: "card-img-top", :alt => "imgfield" cardのimg-top属性を使って綺麗に納めている%>
  <% end %>
```

* グリッドシステムを使って、画像のエリアを真ん中に固定(`<div class="col-md-6 col-md-2 mx-auto">`)

* cssは、画像のインポートは、下記の準備によりできている  
⇒configのwebpacker.ymlで`resolved_paths: ['app/javascript/images', 'app/assets/images']`を追加

③管理者用のナビバー作成と投稿ページ仕上げ

★通常のナビバーをそのまま流用。（左にブログ名と右に後で作るドロアー用のスペースとnoteホーム画面に戻るリンクを）

* noteアプリの通常ナビバーに管理人ブログへのリンクを貼る

```html
<nav id="drawerside" class="navbar navbar-expand-md navbar-light">
      <div class="navbar-brand">Willnote(管理人ブログ)</div>
      <ul class="navbar-nav ml-auto">
        <% if current_user %>

          <li class="nav-item"><%= link_to "ToDoリストへ", root_path, class: "nav-link" %></li>
          <% if current_user.admin? %>
            <li class="nav-item"><%= link_to "投稿する", new_post_path, class: "nav-link" %></li>
          <% end %>
          <li class="nav-item"><%= link_to "ログアウト", logout_path, method: :delete, class: "nav-link" %></li>

          <li class="nav-item drawermark"><i class="fas fa-atlas fa-2x book_green"></i></li>
        <% end %>
      </ul>
</nav>

<% if flash.notice.present? %>
    <div class="alert alert-success" id="FlashAdmin">
      <%= flash.notice %>
    </div>
<% end %>
<script>
'use strict'
$(function(){
  $("#FlashAdmin").fadeOut(5000);
});
</script>
```

④ブログの詳細ページと削除ボタンの実装

⇒引き続きpostコントローラーを修正していく。ルーティングにshowを追加。showアクションにfind_by(id: params[:id])で追記。
次にshowビューを作成。

★ここでビューを途中で書いて、経過を見ようと直接urlに飛ぶ（画面上の上のURLにパスを書く）とimage_tagにnilが入っているのでエラーと出る。これは、コントローラーでfind_byでidを探しているが、直接だと何の投稿画像ページかをidで調べられないためにアクセスできない。（idを入れてパスを入力すればいけるはず）  
⇒後の、indexページから詳細に飛ぶリンクを引数を付けてshowページに繋ぐことでidを元にして検索が出来るようになる。（resourcesしているからidを間に挟むパスになっている）

* 最初に全体を真ん中寄せにして、その中でさらに中を８：４に分ける（class="col-md-8"）因みにここを１２にすれば、上記の真ん中寄せの状態の中でいっぱいに横に広がる。つまり、反対側（ここなら残りの４分）を広くしたいなら左を６にして、右を６にすればいい。

```html  
<!-- containerの中の１２分割を余白１と１（offset）と真ん中は１０。これを実現する、mx-auto(両側からauto) -->
<div class="col-md-10 col-md-offset-1 mx-auto postShow-wrap">
    ~~
  <div class="col-md-8">
    ~~
  <div class="col-md-4">
```

⇒次に、indexの画像から詳細ページと時間表示から飛べるようにする。（要素や画像をリンクにするには、doの構文で挟む）

```html
<%= link_to time_ago_in_words(post.created_at).upcase + "前", post_path(post), class: "light-color post-time no-text-decoration" %>
```

⇒最後に削除ボタンの作成。ルーティングとコントローラーを記述。destroyアクションに`@post.user == current_user`を付けておけば、そのユーザー自身しか削除できなくなる。次に、showページに下に削除ボタンを設置。if  current_user.admin?～endで挟んでおく。

★ここで他のユーザーになって管理人ブログを閲覧するとcurrent_userでデータを取得しているので画像が表示されない  
⇒postコントローラーでcurrent_userでデータを取得すると、他のユーザーにはそのデータが表示されないので見ることが出来ない。indexとshowアクションにPost.allを付ければ閲覧可能になる。因みにn+1問題のincludesでallと同じになるのでallは付けない

★ここでUser.find(1).posts~と書いて直接管理者を指定もできるが、コントローラーにべた書きは良くない。ここでは、管理者が二人ならとか、一般ユーザーも投稿できる時はなどによってコントローラーの書き方が変わってくる。

```ruby
# 変更前は、@posts = current_user.posts.limit~
def index
  @posts = Post.limit(10).includes(:photos, :user).order(created_at: :desc)
end
```

```ruby
# 変更前は、@post = current_user.posts.find_by(params[:id])
def show
     @post = Post.find_by(id: params[:id]) #Post.allと付けてもid検索では無いからエラーになる
end
```

⑤いいね機能の実装

⇒いいねデータには誰のいいねで、どのPostデータの投稿なのかという2つのデータを持たせる。それ以外はそれ自身が何か表示するわけではないので保持するカラムは2種類のみになる

★likesテーブル（Likeモデル）

* post_id(references型 null無し)

* user_id(references型 null無し)

* 検証
⇒belongs_to :user  
⇒belongs_to :post  
⇒validates :user_id, uniqueness: { scope: :post_id }  

★commentsテーブル（Commentモデル）

* comment(text型 null無し)

* post_id(references型 null無し)

* user_id(references型 null無し)

* 検証  
⇒belongs_to :user  
⇒belongs_to :post  
⇒validates :user_id, uniqueness: { scope: :post_id }  
⇒validates :comment, presence: true, length: {maximum: 20 }  

★Postモデルの検証

⇒belongs_to :user  
⇒has_many :photos, dependent: :destroy  
⇒accepts_nested_attributes_for :photos  
⇒has_many :likes, -> { order(created_at: :desc)}, dependent: :destroy  
⇒has_many :comments, dependent: :destroy  

* 一つの投稿は複数のいいねを持てる（has_manyとdependentとorderを記述）

* いいね（id:１）idは一つの投稿(post)に一つのみ（belong_to）
⇒Likeモデルの検証記述。持っているuser_idに対してuniquenessを付けることで同じidのいいねが登録されないようにする（一回しかいいね出来ない）  

★likesコントローラーの作成、ルーティング（resources: createとdestroyでpostの中にネストする）

* createアクションとdestroyアクション編集

```ruby
def create
    @like = current_user.likes.build(like_params)
    @post = @like.post
    if @like.save
        respond_to :js
    end
end

def destroy
    @like = Like.find_by(id: params[:id])
    @post = @like.post
    if @like.destroy
        respond_to :js
    end
end

private

def like_params
    params.permit(:post_id)
end

def login_required #カレントユーザーがtrueではない（ログインしていない）ユーザーは強制でログイン画面へ
    redirect_to login_path unless current_user
end
```

⇒インスタンス作成時にはnewではなくbuildを使う（関連付けの慣習）  
⇒どのpostにいいねを押したかのpost_idを変更できるようにストロングパラメーターにpost_idのみをつける（permitは変更できるキー指定する）  
⇒respond_toメソッドは、レスポンスのフォーマットを切り替えるメソッド

★先ず、`current_user.likes.build(like_params)`で現在操作しているuser_idも含めたインスタンスを作り、@likeに格納。それとは別に、@likeはアソシエメソッドでpostのデータも引き出せるので逆アソシエ（@like.post：@likeはLikeの情報を持っているので）でpostのデータを@postに入れてビューで使えるようにしておく。  
①@postはどの投稿にいいねを押したのかを判断するためにビューで使う。**重要なのは、この@postを作っているのはlikesコントローラーであり、Likeデータをcreateする時に、Postのデータが必要であるという事**

②次に、本来ならredirect_toでページを読むところをリアルタイムで画面に反映させるためにsaveされたら、javascriptのファイルへ飛ぶようにする。（respond_to: js）jsと書いてあるだけだが、そのコードが記載されているコントローラー名とそのアクション名と拡張子がjs.erbのファイルを予測してそこに飛ばしている（createアクションならlikeビューのcreate.js.erbへ飛ばす）

③respond_to :jsはlikeデータがcreateされたら、link_toのフォーマットをｊｓ形式結果を出すようにするためのコード。ビューにあるlink_toのcreateのコードをjsファイルに同じコード書くことで、ビューにあるコードがｊｓ形式でリアルタイムに動く。ビューに書いてあるコードをjsファイルに同じコードを書いてｊｓ形式で読み込む。

```html
<!-- link_toの引数をremote: trueにすることでhtml形式ではなくjs形式でアクションに飛ばす。 -->
<div id="like-icon-post-<%= post.id.to_s %>">
  <% if post.liked_by(current_user).present? %>
    <%= link_to "いいねを取り消す", post_like_path(post.id, post.liked_by(current_user)), :DELETE, remote: true, class: "loved hide-text" %>
    <span class="likecount"><%= post.likes.count %></span>
  <% else %>
    <%= link_to "いいね", post_likes_path(post), method: :POST, remote: true, class: "love hide-text" %>
    <span class="likecount"><%= post.likes.count %></span>
  <% end %>
</div>

～～～
<div id="like-text-post-<%= post.id.to_s %>"> 
  <%= render "like_text", { likes: post.likes } %> 
</div>
```

```ruby
# Postモデルに追記
def liked_by(user)
    Like.find_by(user_id: user.id, post_id: id)
end
```

⇒このメソッドはpostビューで使うので、Postモデルに記述。indexビューには、最初ページが表示された時に、likeデータが入っているかいないかで表示を分けないといけないので、上記のメソッドをビューでif分の条件に使う。このuserという引数には、ビュー側の方からcurrent_userが入ってくる。例えばlikeデータを消すには、その消すlikeデータのuser_idカラムとpost_idカラムが分からないと消せないので、ビューでこのメソッドの引数にcurrent_userを入れてcurrent_user.idでuserのidを取得。post_id: idは、link_toのパスの引数の最初にpost.idをいれてそのままidとして渡している。

⇒likeデータがあれば(present?)、データがある場合は表示されたページのハートは赤くなっており、そのハートはdeleteに繋がる方のリンクになっている。

⇒jsファイルの方は、`#like-icon-post-<%= @post.id.to_s %>`のタグの中に（）内の要素を丸々入れるhtml()メソッドが入っているので、アクションが起きれば非同期でhtml()メソッドの（）内の内容がそのタグに中に入ることになる。因みに、この画像一つ一つをnote.id.to_sで参照出来る訳は、上の方で@postのeach文があり、その中のブロック変数を使ってimageを読み出し、その範囲の中でpost.idとすればその画像のidに絞れるから。そして、jsファイルでは、そのpost.idのpostを@postにすること。また、link_toの引数の「＠」を付けないとエラーになる（外のファイルなのでブロック変数を参照できない）

⇒さらにこのjsファイルは名前も重要で、create.js.erbファイルなら「いいね」を付ける方のコードに付けるべきなのに、「いいね取り消し」の方のファイルに名前が付けられている。これを逆にしてみると動かなくなる。追ってみるとわかるが、likeデータはある時は、「いいね」を取り消すリンクがページに表示されてないといけない。そして、ハートを押すと次にページに現れるのは、「いいね」を付けるリンクがページに表示されないといけない。いいねを付けるリンクの要素はdestroy.js.erbにある。つまりそのファイルは、likeデータをdeleteした後に「いいね」を付けるリンクを表示しているので、destoy.js.erbなのに「いいね」を作成する内容になっている。

⇒likeコメント表示（いいねしました）の j renderは、`escape_javascript`のエイリアスで、改行と括弧をエスケープしてくれるメソッドであり、JavaScriptファイル内にHTMLを挿入するときに実行結果をエスケープするために必要。`_like_text.html.erb`ファイルの内容を非同期にrenderしている。jsファイル内でrenderを使ってhtmlファイルを呼ぶ時は「ｊ」が必要と覚える。renderに変数渡しも、ビューではブロック変数。jsファイルでは@postを使う（さらにここでは、@post.likesというアソシエメソッドを使って_like_textファイルに情報を渡して参照できるようにしている）

```javascript
// create.js.erb likeデータが入ってない時に呼ばれるファイル
$('#like-icon-post-<%= @post.id.to_s %>').
  html('<%= link_to "いいねを取り消す", post_like_path(@post.id, @like), method: :DELETE, remote: true, class: "loved hide-text" %><span class="likecount"><%= @post.likes.count %></span>');
$('#like-text-post-<%= @post.id.to_s %>').
  html('<%= j render "posts/like_text", { likes: @post.likes } %>');  
```

```javascript
// destroy.js.erb
$('#like-icon-post-<%= @post.id.to_s %>').
  html('<%= link_to "いいね", post_likes_path(@post), method: :POST, remote: true, class: "love hide-text" %><span class="likecount"><%= @post.likes.count %></span>');
$('#like-text-post-<%= @post.id.to_s %>').
  html('<%= j render "posts/like_text", { likes: @post.likes } %>');
```

```html
<!-- _like_text.html.erb -->
<strong> <!-- likesはrenderメソッドの変数指定でpost.likes（ビュー）や@post.likes(jsファイル)のデータが入っている -->
  <% likes.each.with_index do |like, index| %> 
    <% if likes.size == 1 %> 
      <%= like.user.name %> </strong> が「いいね！」しました 
    <% elsif like == likes.last %> <!--adminが先にいいねして、次にテスターがいいねしたら、lastメソッドで配列の最後を-->
      </strong>and<strong> 
      <%= + like.user.name %></strong> が「いいね！」しました 
    <% elsif index > 1 %> 
       </strong><%= "と " + "他、" + (likes.size-index).to_s + "人" %> が「いいね！」しました
      <% break %> 
    <% elsif index == likes.size-2 || index == 1 %> 
      <%= like.user.name %> 
    <% else %> 
      <%= like.user.name + ", " %> <!--ここのみなら、テスター②（1234stst）, テスター(stst1234), admin, -->
    <% end %> 
  <% end %> 
```

★ここの解説

* [admim:0]  
⇒size == 1の時に当てはまる

* *[admin:0, テスター:1]  
⇒一週目(admin):sizeは１ではない。lastではない。indexも１以上ではない。  
⇒indexは０でsize-2で０だから条件が合い、名前が出る。この時のstrongタグに開始は1行目のなる。  
⇒二週目(テスター)は.lastに合うので、まず、それまでのコードの部分（admin）をstrongタグを閉じてadmin強調する。  
⇒それに加え「と」を足して、次からstrongを始め、9行目のstrongで閉じる。+ は前のadminと連結するため  
結果：admin と テスター(stst1234) が「いいね！」しました  

* [admim:0, テスター:1, テスター②:2]  
⇒今回は、index２がいる。sizeは３である。  
⇒adminは、今度はindex == likes.size-2 || index == 1には当てはまらない。なので、elseのカンマ区切りの条件になる。  
⇒テスターは、こちらがさっきのindex == 1に当てはまる（結果の途中はadmin, テスターになる）  
⇒テスター②は.lastに当てはまり、結果は、「admin, テスターと テスター②がいいね！しました」になる  

* [admin:0, テスター:1, テスター②:2, テスター③:3]  
⇒adminとテスターはさっきと同じ。次のテスター②が今度は、lastではなくindexが２なので他に当てはまる。  
⇒ここでは、テスター②の名前は出ないで現在のlikeモデルのデータ数だけが表示される。  
⇒さらにbreakなので４週目のループは無い  

★実際の出力では、後にいいねをしたユーザーが配列の先に入っているようなのでが逆に表示される。（上の順番だと、テスター③が配列の最初にくる）

④いいねカウンター
[ヒント](https://techtechmedia.com/favorite-function-rails/)
（このページでヒントを見つけた）

⇒先ず、いいねの数（likeデータ）を取得するには色々やり方があるが、きちんとアソシエが出来ていれば、  
⇒`<%= post.likes.count %>`をコントローラーでアソシエメソッドが使ったインスタンス変数を使った、ビュー、@postやeach文でのpostを使えるビューで書けば、Likeのデータ数がcountメソッドで取れる。

★これをリアルタイムに変えるには先ほどの流れで、

⇒いいねの数字は、createで増えて、destroyで減るのでいいね機能のビューのlink_toと一緒に並べれば、あとはそのコードをjsファイルのhtml()メソッドに一緒に含めれば非同期にできる。jsファイルでは変数を@postにすることを忘れずに。

```html
<%= link_to "いいねを取り消す", post_like_path(post.id, post.liked_by(current_user)), method: :DELETE, remote: true, class: "loved hide-text" %><%= post.likes.count %>
<!-- <%%>と<%%>は並べて使える。もちろん丸々入れられるhtml()メソッドの中でも。その場合が変数を@postにする -->
```

```javascript
// create.js.erb
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいねを取り消す", post_like_path(@post.id, @like), method: :DELETE, remote: true, class: "loved hide-text" %><%= @post.likes.count %>'); 
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
// desroy.js.erb
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいね", post_likes_path(@post), method: :POST, remote: true, class: "love hide-text" %><%= @post.likes.count %>'); 
```

⇒消したり、付けたりの関係なので同じコードをcreateとdestroy両方に書く。  
⇒htmlの加え方で、、ERBは`～％＞＜％＝～`とコンマなしでそのまま続けられるらしいので、ビューでもhtml()メソッドの（）内でもそのままくっ付けて書く。

★いいねカウンターの位置  
⇒🔺ハマり：ハートをクリックするとcssの適応がなくなってしまう（位置がずれる）

★解決：
⇒viewコードにあるハートのリンクを押すと、コントローラーがjsファイルに飛ばして、jsファイルのコードが出力される。
⇒jsファイルのコードにあるjqueryのhtml()メソッドがカギであり、このメソッドの取得した場所（`<div id="like-icon-post-<%= post.id.to_s %>">`）の内側に、タグごとや（`<p>test</p>`）erbテンプレート（`<%=~~%>`）を丸ごと追加できるという機能がある。つまりjsファイルでは、表示する場所（`<div id="like-icon-post-<%= post.id.to_s %>">`）にhtml()メソッドで中身をviewコードの挿入する形になる。
ならば、リンクをクリックしたときに、jsファイルのコードが出力されるわけだから、jsファイルのhtml()メソッドの中に、cssのクラスを含んだタグを入れてあげればいい。

```javascript
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいね", post_likes_path(@post), method: :POST, remote: true, class: "love hide-text" %><span id="likecount"><%= @post.likes.count %></span>');
  // <%>の間にクラス付きのspanタグを入れる
```

⇒因みに、html()メソッドの中に`<p>test</p>`と入れるとハートをクリックすると一緒に出現する。

⑤コメントの実装  
（このデータの紐づきは、いいね機能にコメントを書くデータを付け足したものなので、詳細は上のいいね機能のER図にまとめて書く）

⇒モデル作成、referencesとcommentカラム追加、migrate。  
⇒userとcomment、postとcommentのアソシエ  
⇒commentsコントローラーを作る。ルーティングはcreateをdestroy作り、postルーティングの中にネストする  

* createアクション

⇒こちらは、普通に.newでデータを取り、ストロングパラメーターも普通に入れる。ただし、いいねと同じように途中@postに値を入れる。そして、jsファイルに繋げる。（respond_to:コメントを押したら、リアルタイムでビューを反映させるためにフォーマットをJS形式でレスポンスを返す）

* destroyアクション

⇒いいねとほぼ同じ

```ruby
def create
    @comment = Comment.new(comment_params) #こっちでは、current_user.commentsとしてはいないでbuildも使ってない
    @post = @comment.post
    if @comment.save
        respond_to :js
    else
        flash.now[:alert] = "コメントに失敗しました"
    end
end

def destroy
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    if @comment.destroy
        respond_to :js
    else
       flash[:alert] = "コメントの削除に失敗しました"
    end
end

private

def comment_params
    params.required(:comment).permit(:user_id, :post_id, :comment)
end    
```

★postビューへ

```html
<!-- postのindex.html.erbに記述 -->
<div class="mt-3" id="comment-post-<%= post.id.to_s %>"> 
   <%= render 'comment_list', { post: post } %> 
</div>
<hr> 
                 
<div class="row actions" id="comment-form-post-<%= post.id.to_s %>"> 
  <%= form_with model: [post, Comment.new], class: "w-100" do |f| %> 
    <%= f.hidden_field :user_id, value: current_user.id %> 
    <%= f.hidden_field :post_id, value: post.id %> 
    <%= f.text_field :comment, class: "form-control comment-input border-1", placeholder: "20文字以内でコメント...", autocomplete: :off %>
    <%= f.submit "コメントする", class: "send-comment" %> 
  <% end %> 
</div>
<!-- ここで入力されたコメントがすぐ上のrenderに表示される -->
```

⇒最初のコードは、id="comment-post-<%= post.id.to_s %>"で作成されていくpostのidを取得。to_sでクラス名に入れていく。renderはindexビューファイルでもshowビューファイルでも使うのでここのコードはパーシャルする。ここではindexファイルのブロック変数のpostをpostとして渡している。実際には、ここのrenderの部分にcomment_listファイルのコードが出力される（ここにコメントで打ち込まれた文字が入る）

★パーシャルファイルである_comment_list.html.erbを作成し、記述。

```html
<% post.comments.each do |comment| %> 
  <div class="mb-2"> 
    <span><strong><%= comment.user.name %>：</strong><%= comment.comment %></span> 
    <% if comment.user == current_user %> 
      <%= link_to "", post_comment_path(post.id, comment), method: :delete, remote: true, class: "delete-comment" %>   
    <% end %>
    <!-- ここのif文はコメントした本人がログインしている場合、そのデータにdelete-commentというcssでマークを付けて消せるようにしている -->
  </div> 
<% end %>
```

③app/vies/comments/create.js.erbファイルの作成

```javascript
// create.js.erb
$('#comment-post-<%= @post.id.to_s %>'). 
  html('<%= j render "posts/comment_list", { post: @post } %>'); 

$('#comment-form-post-<%= @post.id.to_s %> #comment_comment').val("");
// ここの機能は非常に大事。下記の🔶へ

=======================================================================
// destroy.js.erb
$('#comment-post-<%= @post.id.to_s %>').
  html('<%= j render "posts/comment_list", { post: @post } %>');
```

🔶重要🔶create.js.erbの`$('#comment-form-post-<%= @post.id.to_s %> #comment_comment').val("");`について

* 上記の機能は２つ  
⇒コメント欄に入力された値を送信したら、入力欄にも値が残らないようにする。（.val("")で空欄を入れる）  
⇒`#comment_comment`が無いと入力してもエラーになる

* ここでは、form_withを囲むクラスのform-postのidからさらに、form_with内で自動生成されたinputタグのidであるcomment_commentをドルメソッドで参照して、その要素のvalueの中身を空欄にしている（**Rails 記法参照**）
⇒今回は、commentモデルのcommentカラムを使っているので、この名前になり、ホームページの検証でも確認ができる。注意は、自身で作成していないので検証を見ないと分からない。そして、このドルメソッド内でカンマ区切りではなく、スペースなので対象を絞っている方である。

★form_withの引数において

```html
<!-- postのindex.html.erb -->
<div class="row actions" id="comment-form-post-<%= post.id.to_s %>">  
  <%= form_with model: [post, Comment.new], class: "w-100" do |f| %>  
    <%= f.hidden_field :user_id, value: current_user.id %>  
    <%= f.hidden_field :post_id, value: post.id %>  
    <%= f.text_field :comment, class: "form-control comment-input border-1", placeholder: "20文字以内でコメント...", autocomplete: :off %> 
    <%= f.submit "コメントする", class: "send-comment" %> 
  <% end %>  
</div>
```

🔶重要🔶

★まず、form_withの引数について、基本ならmodel: @comment記述でrailsがこのアクションに飛ばすという自動予測する記述になるが、今回、postルーティングでcommentのルーティングをネストしているので、親→子の順での書き方をしないといけない。また、空のインスタンスを渡すことがcreateに予測させる条件。  
⇒さらに、ここでモデルのインスタンスを作成する理由は、Post１とPost２というpostがあった場合にそれぞれのpostに対するcommentを作成する必要があるので、ここでインスタンスを作ることにより、スコープを入力したpostに限定して紐づけてcommentインスタンスを作ることができる。外から@commentでやると、どのpostの@commentか分からなくなる、ビュー全体で使えてしまうのでcreateの仕方もおかしくなる。  
⇒ルーティングがネストしていないで、それぞれ独立してcommentルーティングあるときは、model: [@post（ブロック変数ならpost）, @comment]で記述できる。

★また、基本的にはコントローラーのpermitとビューのhiddenでidを取るか、resourcesでネストすればidをparams[:id]でpost_idを取れる、、などがあるが、、
⇒今回は非同期でページ遷移しないので、hidden_fieldで取ってこないといけないなどもあるらしい。（コントローラーで出来ることを参照）

★このform_withは、、postのビューコードなのに、Commentモデルのカラムが使われている（f.text_field :comment）。
⇒コントローラーで@を付けたインスタンス変数なら基本そのビューじゃなくても使える。  
⇒submitのコードは付けなくてもエンターでコメントを送れるようになっているが、分かりにくいので追加。cssも施した。

★仕上げ

* コメントでも一回しかコメント出来ないようにCommentモデルにいいね機能と同じく下記のコードを記述。  
⇒`validates :user_id, uniqueness: { scope: :post_id }`  
⇒また、空欄記入や多すぎるコメントを避けるためにcommetカラムにpresenceとlengthの検証をかける  

* 他のコントローラーにlogin_requiredを付ける(sessionコントローラーはdestroyだけ付ける)

* コメントマークにアンカーを付ける。一応詳細ページのコメント入力へ飛ぶようにした  
⇒参考：[アンカー付け方]<https://qiita.com/tatsuya1156/items/595fe0df912c6c89f991>  
⇒最後にshowページのform_withのtext_fieldの中にautofocus:  trueにすれば選択状態になる  

```html
<!-- index.html.erb -->
<%= link_to "", post_path(post.id, anchor: "anchorComment"), class: "comment" %>

<!-- show.html.erb -->
<div id="anchorComment"> 
  <div class="row parts" id="comment-form-post-<%= @post.id.to_s %>">
    <%= form_with model: [@post, Comment.new], class: "w-100" do |f| %>
      <%= f.hidden_field :user_id, value: current_user.id %>
      <%= f.hidden_field :post_id, value: @post.id %>
      <%= f.text_field :comment, autofocus: true, class: "form-control comment-input bordeplaceholder: "20文字以内でコメント...", autocomplete: :off %>
      <%= f.submit "コメントする", class: "send-comment" %>
    <% end %>
  </div>
</div>
```

⇒最初にshowファイルに飛びたい箇所に専用のidをつける（`<div id="anchorComment">`）  
⇒indexファイルでlink_toにanchorを設定（キャプションは、cssクラスのcommentで画像を入れている）
⇒link_to "キャプション", show.html.erbのパス(その画像のidとリンク先のid)
⇒その画像のidはブロック変数のpostでその画像にlinkの対象に飛ばすためにidが必要

### 管理人ブログにドロアー実装（javascript）

★ドロアーのnavリンクバーの作成（すでにパーシャルでnavは使われているが、navタグを複数使うときの注意は問題無し）

①準備

* まず、`partialadmin/_drawer.html.erb`というパーシャル用のファイルを作り、navタグから始まるulタグとliタグでhtmlコードを作成。link_toのパスはそれぞれで`current_user`の引数を付ける。

```html
<nav id="draweropen">

  <div class="titlemark">
    <i class="fab fa-canadian-maple-leaf"></i>
    WillNote
    <i class="fab fa-canadian-maple-leaf"></i>
  </div>

  <ul>
    <li><%= link_to "投稿一覧", posts_path(current_user), class: "nav-link a_link" %></li>
    <li><%= link_to "プロフィール", adminprofile_path(current_user), class: "nav-link a_link" %></li>
    <li><%= link_to "お問い合わせ", contacts_new_path(current_user), class: "nav-link a_link" %></li>
    <li><%= link_to "ホーム", adminhome_path(current_user), class: "nav-link a_link" %></li>
  </ul>

</nav>
<script>
'use strict'
$(document).ready(function(){
 $('.drawermark').on('click', function() {
   $('#drawerside, #draweropen').toggleClass('show');
 });
}); 
</script>
```

* 通常の管理人ナビバーにドロアー用のアイコンを付ける  
⇒navタグのcurrent_userのみの表示範囲のendの位置調整して、nav-itemもきちんと付けてfontawesomeの大きさを変更してちょうどよい大きさで置く）

②次にpostの`index.html.erbファイル`のcssを編集
⇒今回は、postのindex.html.erbファイルの一番下の方のpostPageとcontainerタグの間にrenderを設置。  
（`<%= render "partialadmin/drawer" %>`）

🔶重要🔶：全ての管理人ブログページにそのcssを付けるために、index,show,newページなど全て同じクラスで囲む  
(class= "postPage")
⇒この中にドロアーナビバーを含めないと（render）、ドロアーのデザインが適応されない

* 先ず、Noteモデル方面のcssと被らないようするためにCSSのセレクタは、必ずpostPageで始めること

* 次にulで付いてしまうmarginとpaddingを０にして、黒点を消す。次に、htmlで言う  aリンクの距離と境界線をもう少し整理したいが、ERBのlink_toの場合、class: の所に名前を付ければCSSセレクタとして選択ができる。そして、aリンク要素は、インラインなのでpaddingなどが効かないので、display:  block;でブロックすれば効くようになる。疑似クラスのhoverには、backgroundを付けるとカーソルを合わせた時にその要素全体の色が変わる

```css
.postPage nav ul {
    margin: 0;
    padding: 0;
    list-style-type: none;
}

.postPage nav ul li .a_link {
    display: block;
    padding: 0.7rem 0;
    border-bottom: 1px solid #114d60;
    text-decoration: none;
    color: #fff
}
.postPage nav ul li .a_link:hover {
    background: #0e3e4d;
```

* 次に、navタグに対してpositionのfixedから始まるテンプレートのCSSを記述

```css
.postPage nav {
    /*ドロアーを画面外へ*/
    position: fixed;
    right: -270px; /*画面から右にナビバー270px分ずらす（画面外に出る）*/
    top: 0;
    /*実際のドロアーの幅と縦*/
    width: 270px; /*全体の横の幅を狭くする*/
    height: 100%;
    /*ナビバーの色と距離*/ 
    padding: 24px 24px 0 24px;
    background: #000;
    color: white;
}
.show {
    transform: translate3d(-270px, 0, 0);/*x軸で-270動かす（左に動かす）*/
}
```

🔺注意🔺：一度ここでナビバーを確認をしたい時は、`position: fixed; right: -270px; top: 0;`を外して見ると下に細長くナビバーが出る。そして、ここで確認のためにcssのshowクラスを付けてみる！postPageクラスと下のnavのクラスにshowを追加してみる。  
⇒するとナビバーに大きく余白が出来てしまい、ナビバーが付いてこなくなってしまう。postIndexとパーシャルの外にdivタグでwrapperにshow置いてもダメ（ナビバーも動かない）containerにshowはナビバーは動くが、上のナビバーに被ってしまう。

⇒そこで、通常の管理人用のナビバーのnavタグにshowを付けたら成功！ちゃんとナビバーの隣にくっついてレイアウトも崩れない！これで確認は出来たので、showを外して、javascriptでそのshowが二つに付けばいい。

🔶重要🔶：ここで重要なのは、コンテナタグの横の要素にナビバーを付けてしまうと、ドロアーが画面の中に入ってきてしまうが、ちょうど通常ナビバーのように画面一杯までで切れる（width100%）所につけるようにすれば、綺麗に画面の切れ目を境にドロアーが横にくっついている。  
また、transform: translate3d(-270px, 0, 0);のshowのｃｓｓを二つに付ける理由は、ドロアーがshowの効果が消えた時に本体の画面も一緒に左にずれないとナビバーに被ってしまう為である。ドロアーが右から出てきたら、本体の画面も左にずれるようにするため、イベントの発火は二つ必要（`$('#drawerside, #draweropen').toggleClass('show');`）
⇒#drawersideは通常の管理人用のナビバーにあり
  
③仕上げ

```javascript
'use strict'
$(document).ready(function(){
 $('.drawermark').on('click', function() {
   $('#drawerside, #draweropen').toggleClass('show');
 });
}); 
```

1. イベント発火させる通常管理人ナビバーの辞書画像にidを付けて（drawermark）、さらにこのマークにcursolプロパティを付与。

2. showセレクタを適応させるために、通常ナビバーとドロアーナビバーのnavタグにそれぞれの別のid名を付ける
⇒管理人用ナビバー「`drawerside`」、ドロアーナビバー「`draweropen`」

3. `partialadmin/drawerファイル`にjqueryコードを書く。ドルファンクションから始めて、その中に最初に発火させるidを取得して、onイベントメソッドのclickイベントに先ほどの、-270左にずれてほしい、ナビバーのそれぞれのidを取得。そこに、toggleClassメソッドでshowクラスを付与する。

4. 追加でドロアーnavタグの中に表題を作るドロアーに上にwillnoteの文字をつける（上記のコードのtitlemarkが付いたコード）

5. 最後に、indexとshowとnewビューのクラス名を同じにしてcssを適用。また、全てのブログ関係用のビューの下にドロアーのファイルをrenderする。  
**⇒これで、通常ナビバーが各ビューの一番上にあり（ドロアーのshowクラスが掛かるナビバーがある）、その下のクラスはpostPageクラスに囲まれ、次にcontainerが来る。ビューの一番下では、containerの影響を受けないようにpostPageとcontainerクラスの間にドロアーファイルのrenderがくれば枠組みは完成！**

### noteタスクのドラッグ＆ドロップとcookie保存

🔺：最初に採用したcookie保存のコードは欠陥があり安定せず、gemのacts_as_listを使ったコードはドラッグと保存は出来ても順番に保存できなかった。ここでは、最初のコードをしっかり読み下したからこそのcookieを使ったコードを使う。

★考え方  
⇒javascriptによるsortからの保存の仕方は2種類ある（データベースに保存とcookieに保存する方法

★準備

* noteindexページのタスク一覧を動かすためにsortable()メソッドを使いたいので、jqueryのＵＩの取り込みが必要
⇒[参考](https://qiita.com/hajimete/items/64a25c08e2f5a3cf929c)

```html
<!--layoutビューのheadに記述  -->
<!-- jqueryは他でインストール済み -->
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
```

* note用のscssファイルを作り、trタグの要素にcursol: move;を付ける

```css
.noteIndexPage table tbody tr:hover {
    cursor: move;
}
```

🔶重要🔶：noteタスクが新規登録される度に作成されるそれぞれのデータのidを取得したい時、そのテーブルデータのタグにid属性を持たせる。そのデータごとのidを取得するには、id名をERBのテンプレートエンジンを使い、note.idで取得する。

⇒trタグにid名をつける。

```html
<tr id="<%= note.id.to_s %>">
<!-- ここにこのように記載をすることで、trタグを参照した時に、それぞれの配列データにidが入る -->
```

★肝は3つあり

* それぞれのnoteデータのidをどう取得するか？（決まったidを取るわけではない）

* jqueryのcookieメソッド使い方と消し方

* reverseメソッドの意味

```html
<tbody class="sortable">
  <% @notes.each do |note| %>
    <tr id="<%= note.id.to_s %>"><%# このidはcookieのid取得に絶対必要 %>
      <td><%= link_to note.name, note_path(note) %></td>
      <td><%= note.created_at %></td>
      <td class="text-center">
          <%= link_to "編集", edit_note_path(note), class: "btn btn-info mr-3" %>
          <%= link_to "削除", note, class: "btn btn-danger", method: :delete, data: {confirm: "#{note.nam削除してよろしいですか？"} %>
      </td>
    </tr>
  <% end %>
</tbody>
```

```javascript
'use strict'
/*上からテスト④(id=66)、テスト③(id=65)、テスト②(id=64)、テスト①の(id=63)順で並んでいる時*/

$(function() {
    $(".sortable").sortable(); /*馬鹿避け*/
    $(".sortable").disableSelection();/*マッチした要素のテキストは選択できない*/
    $(".sortable").sortable({
        update: function(ev, ui) {
            var updateArray =  $(".sortable").sortable("toArray").join(",");
             /* updateArray=65,64,66,63 (tbodyの要素であるtrのidを取っているので、trにそれぞれのidがないとエラー)*/
            $.cookie("sortable", updateArray, {expires: 30});
            /*$.cookie()の値：sort: "40:0,42:1", sortable: "65,64,66,63"*/ 
            /*keyは変数か自分でその場でつけた値の名前*/
        }       
    });
    if($.cookie("sortable")) {
        var cookieValue = $.cookie("sortable").split(",").reverse();/*配列内を逆転させる*/
        /*cookieValue= ["63", "66", "64", "65"] reverseしないと3241のままをさらにdescでひっくり返すので3241の反対の1423になってしまう*/
        $.each(
            cookieValue,
            function(index, value) {$('#'+value).prependTo(".sortable");}
            /*prependToは#+valueの値を入ってる要素の直前に入れる。最初のループは63が入るだけだが、次のループは63の直前に66が入る*/
            /*そうすると、入れた値が直前に入っていくので、65,64,66,63の順になる⇒ソートした正しい順になる*/
        );
    }
});

$('#cookieRemove').on('click', function() {
     var deleteCookie = 'sortable'
     $.removeCookie(deleteCookie);
  });
```

* 🔶重要🔶：最初のコードは、一度sortableをかけた状態から動かすようにする馬鹿避け。つまり、動かせる状態ではないのに動かしてエラーにならないように、最初に準備をしている。前の実装でいきなり動かなくなったり、cookie保存が出来なくなったことがあったが、起動時の準備が出来てないのに動かした結果なのかもしれない。この馬鹿避けは、非同期でも同期でもよくやるテクニックである。

* 今回のreverseメソッドとprepentToメソッドにおいて。prependToメソッドは、１２３４の配列データがあって、最初のループでは、１が入り、次のデータは１の直前に入る。（見た目は２が一番上で１が下）そして、そのように入っていくので、見た目は４３２１の順で上から並ぶ。今回は65,64,66,63であり、これをreverseしないでそのまま表示したら、63, 66, 64, 65の順で表示されるので、最初の移動した66は3番目に来なくてはいけないのに、2番目にきてしまっている。よって、表示する前に["63", "66", "64", "65"]にしておけば、65,64,66,63の順になり正しく表示される。
⇒因みに順番を逆さまにしているのはrails自身ではなくprependTo()メソッドであり、もし普通に下へ順番に入っていくのであればrevarseは必要ないが、それを実現するには少しコードが増えてしまうのかもしれない。noteコントローラーの`.order(created_at: :desc)`は関係ないのはそういうことである。

* toArray()メソッドは、並び替え要素のid文字列を格納した配列を返す。toArrayは、デフォルトでリストの id属性値の配列を返す。

④cookieの削除

```javascript
$('#cookieRemove').on('click', function() {
     var deleteCookie = 'sortable'
     $.removeCookie(deleteCookie);
});
```

🔺ハマり🔺：cookieのデータをリセットするには$.cookie(name); で消すが、前コードではnameに当たる部分をstopイベント内で消さないとnameの値が参照できないと思っていた。しかし、ページが更新された時にある、cookieのnameをページ更新後直接参照出来ることに気付き、ページが更新された時にcookieに保存されているnameを一度変数に入れてから、その値をremoveすれば消せる。

### 管理者用のホームページ

★postコントローラーは作成済みなので、その環境に付け足していく。

1. ルーティングは、オリジナルで作る（get "/adminhome", to:  "posts#home"）

2. コントローラーにhomeアクション追加（中身は要らない）  
⇒特にDBとコントローラーからデータを引っ張るビューではないから

3. postビューにhome.html.erbファイル追加して、通常バナーとドロアー、cssを適用するためにページのクラス名をpostPage、containerを記述して書き始める。

★次に、rails6のwebpackerにおける画像の読み方
[ここを参考に設定](https://qiita.com/hida-yoshi/items/55dc48477201dc195bb8)  
⇒`<%= image_pack_tag "coffee.jpg", class: "test" %>`

★レイアウト

```html
<%= render "partialadmin/blognav" %>
<div class="postPage">
<%= image_pack_tag "coffee2.jpg", class: "hometitle" %>
<%= image_pack_tag "willnote-logo.png", class: "logo" %>
  <div class="container text-center">
    <div class="mt-4 homehead">
      <h1>～美味しい食べ物探しの旅～</h1>
      <p>こちらは管理人のブログでございます<br>
      自由気ままに美味しかった食べ物を投稿しておりますので<br>
      ごゆっくりとお過ごしください。</p>
    </div>
    <div class="archive">
      <h3 class="archivehead">
      <i class="fab fa-canadian-maple-leaf leafbrown"></i>
      スイーツや食べ物
      <i class="fab fa-canadian-maple-leaf leafbrown"></i>
      </h3>
      <div class="archivemain mt-3">
        <figure>
          <%= image_pack_tag "ice.jpg", class: "caption" %>
          <figcaption><strong>～カフェで頼んだコーヒーフロートです～</strong></figcaption>
        </figure>
        <figure>
          <%= image_pack_tag "guratan.jpg", class: "caption" %>
          <figcaption><strong>～近くのイタリアンレストランで頼んだラザニアです～</strong></figcaption>
        </figure>
      </div>
    </div> 
       
  </div>
  <div class="foot">
   <span class="mr-4">
    ~willnote~
   </span>
  </div>
  <%= render "partialadmin/drawer" %>
</div>
```

```css
.hometitle {
    width: 100%;
    height: 450px;
}
.logo {
    position: absolute;
    top: 310px;
    left: 950px;
    width: 300px;
    height: 300px;
}
.homehead {
    font-family: "UD デジタル 教科書体 NP-B","UD Digi Kyokasho NP-B";
}
.archive .archivehead {
    border-top: 1.5px dashed #660000;
    border-bottom: 1.5px dashed #660000;
}
.archive .archivehead .leafbrown {
    color: brown;
}
.archivemain figure .caption {
    width: 300px;
    height: 300px;
    
}
.archivemain {
    display: flex;
    justify-content: space-around;
}
.foot {
    width: 100%;
    height: 50px;
    background: radial-gradient(#FFFF88, #FFC778); 
    display: flex;
    justify-content: flex-end;
    align-items: center;
}
```

* headerの画像の下にlogo文字を入れるが、relativeだとそのままその空間が次の行に残ってしまうので、absoluteで配置

* CSSの画像の配置は、figureタグで縦に並べて、その親クラス（archivemain）にflexをかけて、`justify-content`で等分配置にする。この時、画像自体の幅と高さはきちんと設定すること（そうしないと大きくてレイアウトが安定しない）

* 出来たら、それぞれのナビバーのリンク先を設定

### 管理者プロフィールの作成（グリッドシステム、javascript（切り替え画像）、段取りの振り返り）

🔺注意🔺：切り替え画像の高さにより、グリッドの高さが変わってくるので注意！

①ルーティング、コントローラーアクション(中身は空欄でok)
⇒次にviewファイルの編集（通常ナビバー、ドロアーと同じcssのpostPageクラス、container、ドロアーrender）

🔶重要🔶：全ての管理人ブログページはドロアーが付くため、全てpostPageというクラスの中にドロアーファイルをrenderするそのcssを付けるために、
(class= "postPage")。この中にドロアーナビバーを含めないと（render）、ドロアーのデザインが適応されない

```ruby
get "/adminprofile", to: "posts#profile"
```

```html
<%= render "partialadmin/blognav" %>
<div class="postPage">
  <div class="adminprofile">
     <div class="container">
       <div class="row profileall">

         <div class="col-md-6">
           <div class="text-center mt-3">
             <i class="fab fa-canadian-maple-leaf fa-2x"></i>
             <span class="profileset">プロフィール</span>
             <i class="fab fa-canadian-maple-leaf fa-2x"></i>
           </div>
           <div class="profileparts mt-1">
             <p><i class="fab fa-envira"></i></i><span>ネーム</span></p>
             <p>トシ</p>
           </div>
           <div class="profileparts mt-1">
             <p><i class="fab fa-envira"></i></i><span>好きなモノ</span></p>
             <p>フレンチトースト、辛いラーメン</p> 
           </div>
           <div class="profileparts mt-1">
             <p><i class="fab fa-envira"></i></i><span>勉強中</span></p>
             <p>Ruby、Rails、html、Css、javascript</p>
             <p>Rspec、Git、Sql、Jquery、Ajax</p>
           </div>
           <div class="profileparts mt-1">
             <p><i class="fab fa-envira"></i></i><span>紹介文</span></p>
             <p>好きな食べ物を探しながらプログラミングの勉強をしております。
             特にRubyとRailsを中心に興味があり、お仕事に繋げることが目標です！<br>
             大変な道のりですが頑張ります。
             </p> 
           </div>
         </div>

         <div class="col-md-6 px-0"> <!-- px-0で最初から付くpadding15を0にする-->
           <%= image_pack_tag "frenchtoast.jpg", class: "photoMain" %>
           <div class="row"> <!-- row６をさらに3で4分割する-->
             <div class="col-md-3">
               <%= image_pack_tag "frenchtoast.jpg", class: "select1" %>
             </div>
             <div class="col-md-3">
               <%= image_pack_tag "millecrepes.jpg", class: "select2" %>
             </div>
              <div class="col-md-3">
               <%= image_pack_tag "guratan.jpg", class: "select3" %>
             </div>
              <div class="col-md-3">
               <%= image_pack_tag "ice.jpg", class: "select4" %>
             </div>
           </div>
         </div>


       </div>
     </div>
     <%= render "partialadmin/drawer" %>
   </div>  
</div>

<script>
'use strict'
$(function() {
  $('.select1').on('click', function() {
    $('.photoMain').attr('src', '/packs/media/images/frenchtoast-4ea712ed8b462e5f1c859486ba5d0ff5.jpg');
  });

  $('.select2').on('click', function() {
    $('.photoMain').attr('src', '/packs/media/images/millecrepes-607e9b901fef51895129a475f1f4838c.jpg');
  });

  $('.select3').on('click', function() {
    $('.photoMain').attr('src', '/packs/media/images/guratan-b1588a910863764123c926552075a732.jpg');
  });

  $('.select4').on('click', function() {
    $('.photoMain').attr('src', '/packs/media/images/ice-0a3a95bf323868ddbbbabd23d1005857.jpg');
  });
});
</script>
```

```css
/*adminprofileの画像側の装飾*/
.adminprofile .col-md-6 {
    background-color: #FFFFEE;
}
.adminprofile .profileall {
    width: 800px;
    margin: 0 auto;
    margin-top: 40px;
    margin-bottom: 40px;
    
}
.photoMain {
    width: 432px;
    height: 400px;
}
.select1, .select2, .select3, .select4 {
    width: 110px;
    height: 100px;
}
.select1, .select2, .select3, .select4:hover {
    cursor: pointer;
}
/*adminprofileの紹介側の装飾*/
.adminprofile .profileset {
    font-size: 24px;
}
```

②containerの中にrowクラスを入れて、col-mdの振り分け。先ず、切り替え画像から（右部分）

⇒グリッドシステム：rowクラスは、振り分け用。これを設定すると１２の中なら横並びになる。rowクラスの中にまたrowクラスを入れることも可能。colの中の要素はデフォルトでpadding:15があるので、そのcol自体をcssで指定してpadding:0にすれば隙間はなくなる。bootsrtapでpx-0にすればできる

1. 先ず、大枠のrowクラスにwidthの幅を決めてしまい、margin:0 autoで真ん中寄せ。marginの上下を余白を作り離す

2. それからrowの中をcolで割り振る

3. 左部分は、メインとなる画像コードを記述し、その下にさらにrowクラスを付けて（これが無いと横並びにならない）、col-mdで分割する（col-md-6配下の１２分をさらに4等分する）。分割したcolの中に画像コードを書いて、それぞれにクラス名を付ける（select1, select2...）

4. それぞれの画像をcssで幅と高さを変えて小さく収まるようにする。

5. 次にjqueryコードを書く（下にある小さい各画像をクリックすると、メインの画像が変わるようにする）  
⇒erbのimage_pack_tagの指定はできない？javascriptのままではなく、jqueryの方が指定しやすいかも

🔶重要🔶：ＥＲＢが表示された時のhtmlコードは画面の検証で見ることが出来る。そして、image_pack_tagはhtmlだと、ちゃんとimg～とsrc=""で出力されているので、コードで書いてなくてもimgタグやsrc属性をメソッドの属性値としてセットすることができる！jqrueryメソッドのattr()メソッドでは、（）内で、最初にclassやid、srcなどをセットして、次に属性値やパスを書く。'src'とセットして、次にどこかのネットのhttpsから始まるパスを打てば、src属性をそのパスに変えることができ、画像を出力できる。ここでは、自分がimage_pack_tagのコードをインターネットの検証で見ると、srcの表示もあるので、そのパスをコピーしてattr()メソッドのパスに入れてあげれば、その画像を参照できる。

[今回のヒント①](https://qiita.com/ore_public/items/52b2ce119cb26399d876)  
[今回のヒント②](https://www.buildinsider.net/web/jqueryref/007)

### メールの送受信

* [こちらのサイト](https://www.blograils.com/posts/rails-contactform)と`テックピット`を参考に）

★contactsテーブル（Contactモデル）※今回送るだけなので、外部キーは要らないとした

* name(string型 null無し)

* email(references型 null無し)

* content(text null無し)

* 検証：  
⇒validates :name  presence: true,  length: {maximum: 30 }  
⇒validates :email  presence: true  
⇒validates :content  presence: true  

①準備

⇒先ずコントローラー作成、rails g controller contacts new confirm complete
⇒ルーティングのconfirmとcompleteのHTTPメソッドをPOSTにする（これらのページは入力された項目を送信するため）

```ruby
get "contacts/new", to: "contacts#new" 
post "contacts/confirm", to: "contacts#confirm"
post "contacts/complete", to: "contacts#complete"
```

⇒ja.ymlの日本語表記も追加

②コントローラーとビューの編集（先にcurrent_userしか表示出来ないようにbefore_acrtionをかける）

```ruby
before_action :login_required

  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.save
      render "confirm"
    else
      render action: :new    
    end
  end

  def complete
    @contact = Contact.new(contact_params)
    if params[:back]
      render action: :new
    else
      ContactMailer.received_email(@contact).deliver_now   
    end  
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :content)
  end

  def login_required 
    redirect_to login_path unless current_user
  end
```

★newアクション  
⇒まず、いつもの@contact = Contact.newだけ書いて、先にビューを完成させてしまう。
⇒newビューファイルにalertが出るように追記

🔶重要🔶：ビューのform_withは、model: @contactだけだと、次の行先がデフォルトでindexアクション担当のcontacts_pathになっている。今回、indexアクション、ルーティングを作ってないので、ビューを表示させると下記のエラーが出る。これを解消するには、form_withの次の行先を指定する必要があり、今回の予定はnewページからconfirmページなので、下記のコードで書く。
🔺注意🔺：form_with後の（）はwithの後にくっつけること。（スペースを空けない）

```ruby
undefined method `contacts_path' for #<#<Class:0x00007fffc60a6400>:0x00007fffc60a4498>
Did you mean?  contacts_new_path
```

```html
<%= form_with(model: @contact, url: contacts_confirm_path, local: true) do |f| %>
```

★confirmアクション  
⇒contactのnewビューから、確認用のconfirmビューに一度飛ばすので、createアクションでは、confirmアクションをrenderする（confirmビューで、入力したデータがそのまま使える）
⇒newからcreateでcomfirmをrenderする
⇒comfirmのform_withでは、パスをcompleteにする

🔶重要🔶：confirmビューファイルに関して

⇒確認画面なのでフォーム入力は必要ないが、入力したデータを前のページから(newページから)パラメーターとして持ってきたいので、`hidden_field`でカラム指定をして、コントローラーからの@contact変数をその後に記述する

⇒cssについて、borderの長さを変えたい時は、要素自体のwidthを％で指定して、margin: 0 auto; で真ん中寄せにする

★入力画面に戻る時に入力したパラメーターを残すためには、、  
⇒[参考](https://remonote.jp/rails-confirm-form)  
⇒[参考２](https://www.blograils.com/posts/rails-contactform)  

⇒ルーティングを触ったり、バック用のページを作ったりなど色々あるが、先ず、confirmビューのform_withではcompleteへ繋げるという指定をしている。なので、コントローラーのcompleteアクションにもしbackを使ったら、 `params[:back]`でパラメーターを維持してnewページにrenderするという記述をして、form_withの送信ボタンの所に同じく、submitとしてボタンをおいて、`name: "back"`という決まったコードの記述でデータを維持できる。  
⇒この`name: "back"のname`は属性の`name`ではなく恐らくメソッド用の`name`。最後にcompleteアクションのparams後にbinding.pryを置いたら、やはり入力内容が入っていた。確認画面の時にwindowsの戻るで戻るとルーティングエラーになるので、必ず戻るボタンで戻るようにコメントを下に書く

```html
<!-- confirmビュー -->
<div class="container text-center">
  <div class="mt-5"></div> 
  <h1>お問い合わせ内容</h1>
    <%= form_with(model: @contact, url: contacts_complete_path, method: :post, local: true) do |f| %> 
     <div class="confirm_item">
       <h4>●お名前●</h4>
       <div>
         <%= f.hidden_field :name %>
         <%= @contact.name %>
       </div>  
     </div>
     <div class="confirm_item">
       <h4>●メールアドレス●</h4>
       <div>
         <%= f.hidden_field :email %>
         <%= @contact.email %>
       </div>    
     </div>
     <div class="confirm_item">
       <h4>●お問い合わせ内容●</h4>
       <div>
         <%= f.hidden_field :content %>
         <%= @contact.content %>
        </div> 
     </div>
     <div>
       <%= f.submit "戻る", name: 'back' , class: "btn btn-danger backbotton"%> <%# 前の画面に戻った時に入力内容を残す為%>
       <%= f.submit "送信する", class: "btn btn-primary"%>
     </div>
     <div class="mt-2">
       <i class="fas fa-exclamation-triangle"></i>
       <span>前のページに戻るときは必ず「戻る」ボタンを押してください</span>
       <i class="fas fa-exclamation-triangle"></i>
     </div>
    <% end %>
</div>
```

③acrtionMailerの設定

* まず、googleアカウントを取得(アカウントはevernoteにあり)  
⇒二段階認証無しで安全性の低いアプリ設定をオンにする

⇒次にconfigのenvironmentsの開発と本番にメールの設定を入れる。

```ruby
# 開発
config.action_mailer.raise_delivery_errors = true

  config.action_mailer.perform_caching = false

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
# 本番
config.action_mailer.perform_caching = false

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

◍重要：ここで本番にこの機能で出す場合問題があり、

1. 他の人とソースコードを共有した場合に、コードが見えてしまう

2. デバッグ等で機密情報を変える際、ソースコードから設定を探し出す必要がある
⇒これらの問題を解消するために、環境変数を利用し、その設定をする（３－１）

⇒`dot-env`gemのインストール  
⇒プロジェクト直下に.envファイルを作り、環境変数の設定  
⇒その変数を開発と本番のメールアドレスとパスワードに当てはめる（`ENV[LOGIN_NAME]`）  
⇒`authenticaiton`の項目を`login`にする  
⇒`.gitignore`の一番下に.envを書く

④メーラーの作成（🔺注意🔺：ちょっとでもコードの配置やインデントを間違えるとエラーになる）  
[これも参考に](https://www.blograils.com/posts/rails-contactform)  
⇒rails g mailer contact received_email  
（rails g mailer メーラー名 メソッド名）

結果：

```ruby
create  app/mailers/contact_mailer.rb #誰に向けてメールを送るか。ここにジェネレートしたメソッド（received_email）がある
invoke  erb 
create    app/views/contact_mailer #メールのheaderの内容など
create    app/views/contact_mailer/received_email.text.erb #メールの内容
create    app/views/contact_mailer/received_email.html.erb #メールの内容
invoke  test_unit 
create    test/mailers/contact_mailer_test.rb 
create    test/mailers/previews/contact_mailer_preview.rb
```

★app/mailers/application_mailer.rbの編集（全メーラー共通の設定。ここでは、送信側のメールアドレスを入力）

```ruby
class ApplicationMailer < ActionMailer::Base 
  default from: ENV["LOGIN_NAME"] 
  layout 'mailer' 
end
```

⇒共通の処理・設定を記述する場合には`defaultメソッド`を使用する。`defaultメソッド`のプロパティはいくつかあり、その中の`from属性`はメール送信元名になる。  
⇒これも漏れないようにENVをかける

★🔶重要🔶：app/mailers/contact_mailer.rbの編集

⇒ここでは、誰に向けてメール送るかという設定になる。ユーザーが入力した内容を送るので、コントローラーでの`rceived_email`メソッドにストロングパラメーターの内容を引数にして、そのメソッドを使う。from: @user.email（引数のユーザーのemailカラム）、to:  ENV["LOGIN_NAME"]（内容を自身のアドレスに送る）。ここのfrom: とto:の設定を反対にしたりしないこと。つまり、後に作るメール本文の内容は、自身に向けての（管理者への）メールであり、このユーザーからこのようなお問い合わせがあったという文面でつくることになる。書き方を間違えるとエラーになるので注意！
⇒

```ruby
class ContactMailer < ApplicationMailer 
  def received_email(user) 
    @user = user 
    mail from: @user.email, 
         to: ENV["LOGIN_NAME"], 
         subject: "【willnote】webサイトよりお問い合わせがありました" 
  end 
end

# コントローラー
def complete
    @contact = Contact.new(contact_params)
    if params[:back]
      render action: :new
    else
      ContactMailer.received_email(@contact).deliver_now   
    end  
  end
```

★received_email.text.erbとreceived_email.html.erbの編集（メール本文）  
⇒railsでは、htmlのメールが送れない時は、textメールが送られるようになっている。  

```html
<!-- htmlファイル形式のメール -->
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
  </head>
  <body>
    <h2><%= @user.name %>様よりお問い合わせがありました</h2>
    <hr>
    <p>Name: <%= @user.name %></p>
    <p>Email: <%= @user.email %></p>
    <hr>
    <h3>【お客様のお問い合わせ内容】</h3>
    <div><%= @user.content %></div>
    <hr>
  </body>
</html>

<!-- textファイル形式のメール -->
==============================================
<%= @user.name %>様よりお問い合わせがありました
==============================================

【お客様のメールアドレス】
<%= @user.email %>

【お客様のお問い合わせ内容】
<%= @user.content %>

```

★最後にcompleteページの編集

### 整理整頓

* 入力用のエラーメッセージとログインできなかった時のエラーメッセージの足りてない所の追加と表示の時間を非同期にする
⇒jqueryを使う。メッセージ出力コードの本体にidを設定して、そのfadeout()メソッドを使う

```html
<% if flash.notice.present? %> 
    <div class="alert alert-success" id="flashMessage"> 
      <%= flash.notice %> 
    </div> 
<% end %
<script> 
'use strict' 
$(function(){ 
  $("#flashMessage").fadeOut(5000); 
}); 
</script>
```

* Userモデルのemailの正規表現とpasswordの制限(🔺注意あり🔺)

[参考](https://note.com/simesime/n/n7b9dbf3a80d6)  
[参考：pikawaka](https://pikawaka.com/rails/validation)

```ruby
validates :name, presence: true, length: {maximum: 20}
validates :email, presence: true, uniqueness: true
validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
validates :password, presence: true, length: {minimum: 6, maximum: 20}, on: :create
validates :password, format: { with: /\A(?=.*?[a-z])[a-z\d]{6,20}+\z/ }, on: :create
# formatとwithで正規表現を行う
```

★ここで注意なのが、`on: :create`とかけるアクションを限定しないと登録後のプロフィール変更ができない。プロフィールには、パスワード欄が無いが、検証をかけてない時は、そのままの変更が出来たが、検証をかけると入力が必要になる（confirmationの所）
⇒Userモデルでpasswordの検証の後に、on:  :createを付けることによってupdateの時は必要ないように出来る

* fontawesomeの位置調整

```html
<i class="fas fa-cheese fa-4x cheese" data-fa-transform="down-3"></i>
<!-- data-fa-transformで位置調整を指定できる -->
```

### SEO対策（検索エンジンの最適化）

[項目のそれぞれの説明](http://vdeep.net/rubyonrails-meta-tags-seo)  
[概要](https://creat4869.hatenablog.com/entry/2019/08/15/170109)  
[rails6のファビコン](https://yoshikimi.com/programming/rails/4)  

①先ず上記の概要を順番にやる。helperのコードもコピー  
②ここでは、ツイッターを抜いて、3つの画像を作成する  
⇒ファビコン用とapple用は、上記の`rails6のファビコン`のリンクのジェネレーターで作れる  
⇒ogp画像は、[ここのサイト](https://pablo.buffer.com/)で作れる
注意！:今回のseo用のファイルを使った時の、ファイル名は、適当ではなく、`favicon icon や ogp`という名前のファイルにすること(作成した画像は、app/assets/imageディレクトリの中に入れる)  
③ビューレイアウトのhead内に設定したアイコンが表示されるように`<%= display_meta_tags(default_meta_tags) %>`を記述

### Readme

[参考](https://cpp-learning.com/readme/)
⇒実際のgithubを参考にするのもいいかも（bootsrapなど）

```md
# README

* Name <!-- プロジェクト名 -->  
  =>  willnote  

* Demo <!-- 動作例や画像の貼り付け -->  
  => The Demofile below is how to use willnote. I urge you to see it once.
  ![willnoteデモ](willnoteDemo.gif)

* Usage <!-- willnoteの基本的な使い方など -->  
  => How to use willnote are ...  
  ● You can manage task that you should do.  
  ● Tasks what you saved cans sort on the home screen.  

* Features <!-- 特徴やセールスポイント -->  
  => You can simply register task, and sort yours's task by cookies data.  
     Also, I created a blog. You can see Food image posted by administrator. When you are tired, please take a look for rest.  
     Any other, you can make a comment  on the Food image. Plese hava a try!  
  
* Ruby and Rails version <!-- バージョン -->  
  => ruby 2.7.0  
  => Rails 6.0.3.4  

* Requirement <!-- willnoteを動かすためのライブラリなど -->  
  => rbenv 2.7.0  
  => yarn 1.22.5  
  => Bundler version 2.1.4  
  => node v10.19.0  

* Licence <!-- ライセンス -->  
  => This software is released under the MIT License, see LICENSE.txt.
  
* Author <!-- 作成情報 -->
  => Toshiki Shimano
```

★基本的には、デモ画像があれば基本はいいらしいが、、

①Nameはプロジェクト名  

②Demo（gifを作成するのがいいかも）
⇒screenToGifを使って録画する。このgifの画像のパスを貼り付け、軽く説明。  
⇒read meはマークダウン形式で記述できるので、同じディレクトリの中にgifファイルを入れて、下記の形式で書くとリンクになる

```md
![](willnoteDemo.gif)
同じ配下のあればパスもいらず、ファイル名でいける
```

③[ライセンス](https://www.catch.jp/oss-license/2013/09/27/mit_license/)
⇒ここを参考にファイルを作っていく

### Gitの設定(詳しくはgitについてを参照)

★ポートフォリオの上げ方

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

★基本操作

⇒プロジェクトのファイルを一部変更。そのファイルをステージングする時には、`git add パス名` になるが、このパスを間違えるとうまくいかないので、正式を見るには`git status`で見るとパスが分かる。  
⇒ファイルを変更した後に、もし完全にスペースなども考えファイルのコードを戻せるなら手動で戻すか、Ctrlとｚで最後まで戻せるなら、それを再保存すれば変更状態は解除される。  

⇒ステージングしたファイルの内、特定のファイルをコミットしたい場合は

```git
git commit -m 'test' --controllers.rb
git commit -m 'test' --controllers.rb test.rb ＃複数の場合
```

### rspec（rails6のエラーあり。最初のrspecのgemインストール注意！テックピットは1章2章要らない）

★最初にrspec.mdのまとめを見て環境構築をする。

★ここでは、先にNoteモデルとUserモデルのテストから始める

★notesテーブル（Noteモデル）

* name(string型 null無し デフォ無し)

* memo1(text型)

* memo2(text型)

🔺最初からアソシエするなら

* user(references型  null無し)
⇒user_idとインデックスの自動追加

★usersテーブル（Userモデル）

* name(string型 null無し デフォ無し)

* email(string型 ユニークtrue、null無し デフォ無し)

* password_digest(string型)
⇒passwordとpassword_confirmation

🔺後で追加

* admin追加（boolean  null無し）

1. willnoteへのログインの動作確認（userデータが登録されている必要あり）  
2. noteデータがちゃんと登録されるか  
3. ここでは、UserモデルとNoteモデルが紐づいていることも考慮に入れる  

⇒以上を踏まえて、速習の順番で進めていく

①factorybotの編集

```ruby
# notes.rb
FactoryBot.define do
  factory :note do
    name { "rspecテスト" }
    memo1 { "system spec" }
    memo2 { "FactoryBot" }
    user
  end
end
# users.rb
FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "test@au.com" }
    password { "password" }
  end
end
```

* ファクトリー名（:user）をモデルと違う名前で付けるときは、クラスを指定して名前を付ける
（`factory :user do`を`factory :admin_user, class: User do`）

* noteのファクトリーには、下にuser（factory名）を付ける。アソシエーションしているから

②テストファイルの編集

```ruby
# spec/system/note_spec.rb
require 'rails_helper' #全てのテストファイル付ける

RSpec.describe Note, type: :system do
  describe "Noteモデルの検証や登録について" do
  let(:user_a) { create(:user, name: "ユーザーA", email: "a@au.com") }
  let(:user_b) { create(:user, name: "ユーザーB", email: "b@au.com") }
    context "ログイン状態のケース" do
      before do
        create(:note, name: "rspecテスト", user: user_a)
        create(:note, name: "system勉強", user: user_b)
        visit login_path
        fill_in "メールアドレス", with: login_user.email
        fill_in "パスワード", with: login_user.password
        click_button "ログインする"
      end

      context "ユーザーAがログインした時" do
        let(:login_user) { user_a }
        it "ユーザーAの作成したタスクが表示される" do
          expect(page).to have_content "rspecテスト"
        end
      end

      context "ユーザーBがログインした時" do
        let(:login_user) { user_b }
        it "ユーザーAのタスクは表示されない" do
          expect(page).to have_no_content "rspecテスト"
          expect(page).to have_content "system勉強"
        end

        it "ユーザーBが物理削除されたらタスクも消える" do
          expect( Proc.new {user_b.destroy}).to change{ Note.count }.by(-1)
        end
        it "ユーザーBが論理削除されたらタスクは残る" do
          expect( Proc.new {user_b.discard}).to change{ Note.count }.by(0)
        end
      end
      
    end
  end
end
```

* create(:note, name: "最初のタスク", user: user_a)のuser: はnoteファクトリーファイルの下につけたuser

* capubaraのfill_inの後に書く、”ログインする”などは、実際に画面上にその名前の欄があり、コードのラベル名にも書かれていないと効かない

* ユーザーを作成する時にadminをtrueにするか確認する

★テストファイルの編集において

* ログインが必要なシステムはまずそこから書かないといけない

* createやnewを変数に代入する場合、それを後で使うなら「＠」を付けると使いまわせる。付けないと他の場所で使えない。後は、＠を使わない変数を使う場合、スコープを考えてit文を作るなら、同じ変数データを使うにしても、もう一度.newなど記述をしないといけない

* .newで自身でデータを作成する時とfactorybotでデータ作成を行う違いについて。同じメールアドレスの登録が出来ないことを検証するとき、factorybotで先に用意してしまうと、そもそも最初から同じデータが作られてしまうので、コード自体通らない(使うなら、create後のemail:を記述して属性を代入すること)。流れの中でデータを作りたいなら、factorybotを使わないで自身で順番に上から.newでインスタンスを作っていくと、その流れに沿って検証を行える。

* letは、decribeかcontextの配下ではないと効かない！it配下では使えない

* before doにログインの流れを入れている場合、ログインを必要としないテストーケースがある時は（単純な.newなど）、そのケースをbefore doの及ばない箇所に記述すること（ログインのbeforeとそれを必要とするケースをcontextで囲み、その外に新しく記述すれば、ログインの影響を受けない）

* 原則として「1つの example につき1つのエクスペクテーション」で書いた方がテストの保守性が良くなる。

#### rspecを使って考えるテスト

★アソシエを結んでいるuserとnoteの関係で（has_many :notes, dependent: :destroy）、ユーザーが削除されると、タスクも消えるか  
⇒[ここを参考に](https://qiita.com/paranishian/items/51d3742b7095aa7744ca#%E5%8F%82%E8%80%83)  

⇒今回user_bがdestroyされたら、changeマッチャを使って、Noteモデルのデータが減るというケースを考える。(上のテストファイル参照)  
⇒まず、アソシエとログインしないとアプリを使えないので、factorybotを使ってアソシエしたタスクを作って、capybaraを使ってログインをする。  
⇒ここで、it構文の中身をchangeメソッドの書き方でこのように書きたくなるが

```ruby
expect(user_b.destroy).to change{ Note.count}.by(-1)
```

⇒ここでテスト実行すると、`but was not given a block`というエラーが出る。そこで何でもいいのでブロックの形で渡せばという考えで、user_cをProc.newでプロックオブジェクトにしてやるとうまくいく。（changeはexpectの内容をブロックにして渡さないといけない）

```ruby
expect( Proc.new {user_b.destroy}).to change{ Note.count }.by(-1)
expect( Proc.new {user_b.destroy}).to change{ user_c.notes.count }.by(-1)
#どちらでも通る
```

#### sessionコントローラーテスト

⇒コントローラーをテストするには、spec下にrequestsディレクトリを作って、rspecファイルのtypeをrequestにする。一番簡単なテストがこちら

```ruby
require "rails_helper" 
RSpec.describe "sessionコントローラー", type: :request do 
  describe "正しくログインできるか" do 
    it "ログインできるか" do 
      get "/login" 
      expect(response).to have_http_status(200) 
    end 
  end 
end
```

⇒200は、リクエスト成功のステータスコードで、 ページがちゃんと表示されていれば通る。302はリダイレクト。  
**★準備の仕方とオリジナルhelperメソッドを使うための準備は、rpsec.mdを参照**

#### 画像の登録のテスト(systemspec)

★画像のコードの書き方は、rspec.mdの前知識を参照

* 画像の呼び出し方は、`Rack::Test::UploadedFile.new(File.join(Rails.root, '画像ファイルがある場所のパス'))`
⇒specディレクトリ内にfixturesというディレクトリを作成して、そこに画像を置く

```ruby
RSpec.describe Post, type: :system, js: true do #このテストでは殆んどjsを使うのでここにjs: trueを設定
  describe "画像投稿に関する機能テスト" do
  let(:user_admin) { create(:user, admin: true, id: 1) } #admin用のボタン検証するためにidを設定
  let(:post_admin) { Post.create( caption: "test", user_id: user_admin.id, id: 10 )} #登録された画像を追うためにidを設定

    before  do
      @photo = Photo.create(
        image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/forest.jpg')),
        post_id: post_admin.id
      )
      visit login_path
      fill_in "メールアドレス", with: user_admin.email
      fill_in "パスワード", with: user_admin.password
      click_button "ログインする"
      click_link "管理人ブログ"
      find('.drawermark').click
      click_link "投稿一覧"
    end

    context "adminユーザーの画像登録において" do
      it "画像が登録されている" do
        expect(@photo.save).to be_truthy
      end

      it "いいねが出来ている" do 
        find('#like-icon-post-10').click
        expect(page).to have_content "いいね！"
      end
```

⇒UserモデルとPostモデルとPhotoモデルのアソシエ（id）を考える  
⇒imageのパスは画像があればどこのディレクトリでも大丈夫なので、テスト用にrspec下に置いてもいいし、直接画像があるjavascript下から追っても良い

#### rspecとcapybaraとjavascript

* [javascriptの設定とやり方](https://qiita.com/koki_73/items/ffc115ed542203161cef)

⇒本記事では、featuteテストで行っているがsystemテストでも同じようにできる  
⇒describe、context、itのdoの直前に`js: true`を入れるとcapybaraで触れるようになる（jsを使いたい所に記述する）

🔺注意🔺：投稿画像一覧に飛べないエラーについて：下記は通らないコード

```ruby
#上の正しいコードと見比べてみる
RSpec.describe Photo, type: :system, js: true do  
    before  do 
        @user = create(:user, admin: true) #ここが問題！
        @post = Post.create( 
            caption: "test", 
            user_id: @user.id 
        ) 
        @photo = Photo.new( # ここが問題！
            image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/forest.jpg')), 
            post_id: @post.id 
        ) 
        visit login_path 
        fill_in "メールアドレス", with: @user.email 
        fill_in "パスワード", with: @user.password 
        click_button "ログインする" 
        click_link "管理人ブログ" 
        find('.drawermark').click 
        click_link "投稿一覧" 
    end 
    it "trueを返す" do 
        expect(@photo).to be_valid 
    end
```

🔺エラー🔺：find~clickでドロアーをクリックは出来たけど、次のclick_linkで投稿一覧にいけない  
①user_idの１が見つからない  
②それを解消しても、imageにデータが登録されてない  

🔶重要🔶：①のエラーについて
⇒このエラーは、ブログの画像の作成は管理者しか出来ないという設定しており、表示される画像もpostコントローラーでUser.find(1).posts~でデータを表示させるようにしていたので、実際には投稿一覧にはユーザーid(1)が表示されないといけないという自身の作った環境が原因。そもそもテストデータが作られている時にユーザーidが１で作られているかわからないということもあったので、先ず、userをcreateしているrspecファイル中にbinding.pryを置いてみる。そうするとidが１ではないユーザーが作成されていたので、userをfactorybotでcreateする時に、user_id: 1に設定したら、そのユーザーが作成された。

🔶重要🔶：②のエラーについて
⇒user_id: 1 が作られると今度は、imageがnilというエラーが出る。これも事態が掴めなかった為に、binding.pryで@photoを調べてみたら、確かにデータが入ってなかった。その時に、Photoデータの作られ方に目がいった為に気付けたが、どうやらモデルからデータを作成する時に、.newで作成していたのが原因だった。引数は持っていたのにデータは入ってなかった。これを.createにすることによってimageデータがちゃんと入っていた。

～総括～
⇒以上の事から、ドロアークリック後にclick_linkでそのリンクに飛ぶこと確認ができ、テストも通った。自身で画像一覧ページは、find(1)で設定しているのでテストユーザーの作成にもidを１にすることを忘れないようにする。

#### お問い合わせテスト(メール用のマッチャを使うには)

★前提

* 今回は、mailer specになるので、ディレクトリ名をmailers、spec内のtypeをmailerにする

①config/environments/test.rbの中で、

```ruby
config.action_mailer.delivery_method = :test
```

とあるが、これのおかげでspec内で`ActionMailer::Base.deliveries.last`というコードでActionMailerインスタンスを取得できる。`ActionMailer::Base.deliveries.last`の戻り値を変数か（@mailなど）subject入れて使う。
⇒このメソッドは、必ず、deliveriesのあとに何かしたら付けないとエラーになる。これでメール情報を取得できるので、マッチャと組み合わせてテストする。

★メソッド一覧

* ActionMailer::Base.deliveries.last(最後に送信されたメールを取得)

* ActionMailer::Base.deliveries.last.body(最後に送信されたメールの本文を取得)

* ActionMailer::Base.deliveries.first(最初に送信されたメールを取得)

```ruby
require "rails_helper"

RSpec.describe Contact, type: :mailer do
    after { ActionMailer::Base.deliveries.clear } 
    let(:new_mail) { Contact.create(name: "test", email: "test@au.com", content: "日本語テスト") }
    let(:mail) { ContactMailer.received_email(new_mail)}

    it "メールが実際に送られているか" do
        expect do
            mail.deliver_now
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    context "送られたメールの内容がきちんと取得できる(email_spec使用)" do #deilver_nowは必ずit内に記述する
        
      it "宛先へ送られている" do
          mail.deliver_now
          expect(open_last_email).to deliver_to(ENV["LOGIN_NAME"]) 
      end

      it "記入した件名が記載されている" do
          mail.deliver_now
          expect(open_last_email).to have_subject("【willnote】webサイトよりお問い合わせがありました") 
      end
      
      it "記入したメール内容が記載されている" do
          mail.deliver_now
          expect(open_last_email).to have_body_text(/日本語テスト/) 
      end
    end
end
```

* メールの本文（body）は本文以外の情報(encodingなど)も含まれるため、eq matcherではなくmatch matcherを使用する。そのためにメール本文をdecodeしないと日本語のテストができない。

```ruby
let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }
```

⇒上記のようなことで文をencodeもできるが、上記のコードは日本語（UTF-8）対応していない。

★`gem email_spec`のインストール

⇒[下準備の所だけ見る](http://totutotu.hatenablog.com/entry/2015/09/23/%E3%80%90%E3%83%86%E3%82%B9%E3%83%88%E7%B7%A8%E3%80%91ActionMailer%E3%81%A7%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%92%E9%80%81%E4%BF%A1%E3%81%99%E3%82%8B)

⇒[公式ホームページ](https://github.com/email-spec/email-spec#rspec-matchers)  
⇒ここでは、マッチャのメソッド（have_subjectなど）を確認。途中のページにある、rails generate email_spec:stepsコマンドをやると、expect内で使えるオプションの内容が見れる）

🔶重要🔶：githubの公式に色々あるが、、基本的には、gemをインストールして、rails_helperに「require"email_spec"」を記述（つけなくてもなぜか動く）

⇒必ず、rails_helperに

```ruby
RSpec.configure do |config|配下に

config.include(EmailSpec::Helpers) 
config.include(EmailSpec::Matchers)
```

を入れるか、specファイル内でincludeする。（これは記述しないとエラーになる）

```ruby
describe "Signup Email" do 
  include EmailSpec::Helpers 
  include EmailSpec::Matchers  
end
```

🔺注意🔺：ここでマッチャの方に目が行きがちだが、、expectの`open_last_email`のように対応したメソッドを使わないとマッチャも使えないようになっている。

```ruby
mail.deliver_now
expect(open_last_email).to deliver_to(ENV["LOGIN_NAME"]) #open_last_emailと使わないとdeliver_toが使えない
```

⇒上記のmailはletで定義したメソッドだが、この設定にもきちんとContactモデルからcreateして、そのデータをmailerをジェネレートした時に作ったreceived_emailメソッドに入れてメールを生成すること  
（このreceived_emailは以下のapp/mailer/contact_mailer.rbというActionMailerでジェネレートした時に作成したクラスのメソッドを持ってきている）

```ruby
class ContactMailer < ApplicationMailer
  def received_email(user)
    @user = user
    mail from: @user.email,
         to: ENV["LOGIN_NAME"], #自身にお問い合わせが来るように設定
         subject: "【willnote】webサイトよりお問い合わせがありました"
  end
end
```

🔶重要🔶さらに、メールを送るメソッドのdeliver_nowメソッドは、received_emailメソッドの後ろに付けて使えるはずなのだが、これをletなどにまとめてしまうとそのletの中で送信が完結してしまうらしく、リアルタイムに反映させるためにはit文の中でdeliver_nowメソッドを使う必要がある。

### 論理削除

★論理削除を実装するのに便利なgemが二つあるが、paranoiaは非推奨（ActiveRecordをオーバーライドしてしまいコンフリクトする可能性がある）なのでdiscardを使う

★discardについて
[参考：基礎](https://qiita.com/piggydev/items/05e7276ed0cada69da76)

①`gem 'discard'`をインストール

②discard機能を使う予定のmodelへの追加マイグレーションファイルを作成（今回ならUserモデルへ：usersテーブルに追加）

```linux
rails g migration add_discarded_at_to_users discarded_at:datetime:index
```

⇒変更せずmigrateする。因みに今まで作成されていたユーザーにも自動的にこの属性が付与されるので消さなくても大丈夫

③Userモデルでdiscardを機能させることを宣言

```ruby
include Discard::Model
```

④新たにユーザーを作って、discard_atカラムが付くのを確認。実際にコンソールでユーザーを論理削除すると、データベースからの検索はできる。  
⇒ビューコードのlink_toのコードは変更しなくて大丈夫（method: :deleteはあくまでルーティングからコントローラーのdestroyアクションに飛ばすための記述）  
⇒destroyアクションのdestroyをdiscardに変えると論理削除できる。何も工夫をしないで実際の画面から削除すると、画面にデータが残ったままになってしまうので⑤へ

⑤画面に論理削除されてないユーザーのみ表示する  
⇒Userモデルに下記のコードを記述すると、usersコントローラーindexアクションのUserの後ろに付けるもので表示が変化する

```ruby
default_scope -> { kept } #実はこれは要らない

# indexアクションに、、
@users = User.all #disされてないユーザーが残る
@users = User.with_discard #全てのユーザーが残る
@users = User.with_discard.discard #disされたユーザーだけ残る
```

🔺注意🔺：上の設定だと画面から消えたdisされたユーザーはコンソールで検索できなくなってしまう。代わりに、disされたユーザーだけが残るコードにすれば画面上は確認できる。
⇒`User.all`と`User.with_discard.discard`の変数を分ければ別々に表示はできるが、、表示するときは直接`<%= disusers.name %>`とダイレクトに打ってもエラーになるので、each文で変数を一度ブロックに渡す必要がある。（`<% @users.each do |user| %>`）

🔶解決🔶：モデルにkeptと打ってしまうとコンソールでも表示されない為、コントローラーにUser.keptと記述すると画面には表示されず、コンソールには出てくるようになる。

```ruby
def index
    @users = User.kept
    @disusers = User.with_discarded.discarded
end
```

⑥削除を退会にする  
⇒ビューの削除ボタン退会に変更  
⇒indexアクションに`@disusers = User.with_discarded.discarded`を記述  
⇒ユーザー一覧のビューに<%= @disusers.count %>を入れて退会者数が分かるようにする

```html
<table>
    <tr><th>『退会者数：<%= @disusers.count %>』</th></tr>
</table>
```

* 退会にしたユーザーを戻すには、ターミナルでpostgreに繋いでから、コンソールで`User.discarded`で退会したユーザーの一覧が見えるので、そのidを使って、User(3).undiscardすれば復活する

### ページネーション

★[公式](https://github.com/kaminari/kaminari)  
★[ピカワカ基礎](https://pikawaka.com/rails/kaminari)  
⇒ページネーションを作成すれば、背景画像の無駄な拡大を防ぐこともできる。

🔺注意🔺：今回この実装において、postindexビューでページネーションが出ないという事が発生。このgemに限らずだが、このgemではnavタグに影響があり、postページのドロアーのコードの中に<%= paginate @notes %>を入れるとnavクラスのページネーションまで外に行ってしまうため、postpage  navのcssに入らないようにこのコードを入れること。
⇒つまり、postindexビューではpostPageクラスの中にドロアーrenderのコードがあるが、その外に置かないと、ページネーションのnavタグもpostPage navの影響を受けてしまう

* pageメソッド：page(params[:page])を渡すとビューで<%= paginate @notes %>のように使えるようになる

* perメソッド：per（）の引数に１と入れると1データで1ページになる

```ruby
def index
    @notes = current_user.notes.order(created_at: :desc).page(params[:page]).per(5)
end
```

★ビューに下記のコードを入れるとper()ごとのデータのページネーションが表示される

```html
<%= paginate @notes %>
<%= page_entries_info(@notes) %> <!-- こちらのコードは、ページの件数を表示する -->
```

★上記だけだと見た目を変えられないので、下記のコードでkaminari用のviewファイルを作る

```html
rails g kaminari:views bootstrap4
<!-- viewsの後に、自身の使っているcssフレームワークを必ず付けること。これを作成してからビューのページネーションを見ると、ただの数字だった表示に枠がついて、bootstrapが適応されたデザインになった。 -->
```

⇒このコマンドでviewにkaminariディレクトリが作成され、7つのファイルが出来上がる。これらは、表示されるページネーションの一つ一つのボタン（最初ボタン、最後ボタン、ページボタン、次へボタンなど）の表示を扱っており、ここを変えると影響が見られる。

* config/locales/にkaminari_ja.ymlファイルを作り、テンプレート（ピカワカ）を貼る。（この記事はここまで見ればよい）  
⇒これでページネーションが日本語表記になる

* page_entries_infoもymlファイルで表示を変えられる

* 以下のコマンドでkaminariのコンフィグを作成できる(これは必要ないかも)

```linux
rails g kaminari:config
```

★ページネーションのcss編集

⇒先ほど、kaminari用のviewファイルを作成したが、これらのファイルにはいくつかクラスで名前がつけてあり、例えば、_pagentor.html.erbのファイルには`pagination`というクラスの名前がulタグについており、下記のようにcssを変えると中央寄せができる。つまり、kaminariの各ファイルのクラスを把握すれば自由にデザインできる

```css
.pagination { 
  justify-content: center; 
}
```

* 件数表示は検証を見てみるとクラスが指定されてないので、text-centerを指定すれば真ん中に移動する
  
```html
<div class="text-center"><%= page_entries_info(@notes) %></div>
```

★ページネーションｃｓｓの各クラス

* .pagination
⇒ページネーション全体部分  
⇒中央寄せするなら

* .page-item
⇒表示されている枠部分の範囲

* .page-link
⇒数字とその背景

* .active
⇒このクラスが付いているだけでcurrent(現在のいるページ)ページが青くなる

* 'views.pagination.truncate'などviews.～というコードはymlのメソッドを呼んでいる。（表示の出方）

### インクリメンタルサーチ（ユーザー管理一覧）

[インクリメンタルサーチ](https://qiita.com/yuki-n/items/fdc5f7d5ac2f128221d1)

⓪最初に流れを簡単に表すと、、

1. クラス名ID名が付いた検索窓を作成（formタグ）  
2. 検索窓から入力されたデータを取得（jqueryのfunctionメソッドとval()メソッド）  
3. 取得したデータをajaxでリクエスト送信（表示したいURLにではなく、中間アクションへ送る）  
4. 中間となるアクションから表示したいページのアクションへrenderするようにする  
5. 表示したいアクションにデータが届いたら、done()メソッドを使って、表示する処理を決め、ビューにその結果を表示するコードを書く

①先ず、userのindexビューに検索窓を設置

```html
<input type=form id="form" placeholder="ユーザー名を入力してください" style="width: 250px;"/>
```

②次に、jsファイルを用意（今回は、javascriptディレクトリ内に設置：このファイルが有効になるためには、application.jsでファイル名を読み込み、jqueryをrequierする）

```javascript
$(document).on('turbolinks:load', function(){ //リロードしなくてもjsが動くようにする
    $(document).on('keyup', '#form', function(e){ 
        e.preventDefault(); //キャンセル可能なイベントをキャンセル
        var input = $.trim($(this).val());
～～～～～～～
```

>jQuery(document).readyや、 $(function()の記述では、ページの読み込みを起点として発火します
>⇒つまり、画面の一部が切り替わった場合はイベントが発生しないことになります。
>⇒そこで、Turbolinksを無効化させる、Ajax後にも発火するように設定する、ということで対処していきます。

* inputタグのform属性とイベントのkeyupに関する流れで、preventDefaultをかけないとデフォルトでついてくる必要のない動作をしてしまう

②ajaxメソッドを追記

```javascript
$(document).on('turbolinks:load', function(){ 
    $(document).on('keyup', '#form', function(e){ 
        e.preventDefault(); 
        var input = $.trim($(this).val()); 
        $.ajax({ 
            url: '/users/search', //urlを指定
            type: 'GET', //メソッドを指定
            data: ('keyword=' + input), //コントローラーに渡すデータを'keyword=input(入力された文字のこと)'にするように指定
            processData: false, //おまじない
            contentType: false, //おまじない
            dataType: 'json' //データ形式を指定
        })
```

⇒`data: ('keyword=' + input)`について、ここでは、inputは取得してきた値が入った変数。そしてその内容を、keywordという変数に入れて、その変数をコントローラーで使いデータを渡せるようにする（渡すときは、params[:keyword]で受け取る）

③ajaxで指定したルーティングを作る  
（一度別のアクションに飛ばして、そのアクションから表示させたいアクションへ飛ばす。この中間アクションにビューは要らない）

⇒ルーティングを設定して、usersコントローラーにsearchアクションを作る。

```ruby
resources :users, only: %i(index create destroy edit update) do 
    collection do 
      get 'search' 
    end 
  end
～～～～～～～～～～～～～
# usersコントローラー
def search 
  @users = User.where('name LIKE(?)', "%#{params[:keyword]}%")  
  respond_to do |format|  
  format.json { render action: :index, json: @users }  
  end 
end
```

⇒whereのlike検索の第二引数に使うワイルドカードで検索の一致の仕方を変えられる。完全一致なら、like検索の％を両方外すか、下記の方法もある

```ruby
@jsusers = User.find_by(name: params[:keyword])
```

④ユーザー管理一覧のビューに検索結果を出したい場所にクラス名付きのulタグを記述

```html
<ul id="result">
<!-- この中に<li>ユーザー名</li>みたいに検索候補を追加していきます -->
</ul>
```

⑤jsファイルのajax()メソッドの後にdoneメソッドでulタグの中にsearchアクションから送られたデータを元にliタグを入れるコード記述

```javascript
$(document).on('turbolinks:load', function(){ 
    $(document).on('keyup', '#form', function(e){ 
        e.preventDefault(); 
        var input = $.trim($(this).val()); 
        $.ajax({ 
            url: '/users/search', 
            type: 'GET', 
            data: ('keyword=' + input),  
            processData: false, 
            contentType: false, 
            dataType: 'json' 
        }) 
        .done(function(data){ 
            $('#result').find('li').remove(); 
            $(data).each(function(i, user){ 
              $('#result').append('<li>' + user.name + '</li>') 
            });  
        }) 
    });   
});
```

⇒append()は、指定した子要素の最後にテキスト文字やHTML要素を追加することができるメソッドなので、ulにresultをidを置いて、その子要素の最後に足していく  
⇒remove()メソッドは、検索して引っかかったliがどんどん増えていかないために付ける。(append()メソッドが追加していってしまうから)

🔶重要🔶：検索窓で入力が空になると全ての結果出でしまう問題について

⇒検索時に文字が入力されている時はきちんと表示されるが、その文字を消して空にした時に全ての検索結果が出てしまうことについては、if文で入力文字あるなら（if(input)）表示をして、空なら（else）liタグを消す流れにすれば良い

```javascript

  if(input){ //inputがtrueなら（文字があるなら） 
      $.ajax({ 
          url: '/users/search', 
          type: 'GET', 
          data: ('keyword=' + input),  
          processData: false, 
          contentType: false, 
          dataType: 'json' 
      }) 
      .done(function(data){ 
          $('#result').find('li').remove(); 
          $(data).each(function(i, user){ 
            $('#result').append('<li>' + user.name + '</li>') 
          });  
      }) 
  } else { //文字がある以外なら（文字が無いなら） 
      $.ajax({ 
          url: '/users/search', 
          type: 'GET', 
          data: ('keyword=' + input),  
          processData: false, 
          contentType: false, 
          dataType: 'json' 
      }) 
      .done(function(){ 
          $('#result').find('li').remove();   
      }) 
  } 
```

⑥仕上げ

```html
<table class="table table-bordered table-warning" style="width: 450px; margin-left: 55px">
      <tr><td><strong>『ユーザー検索』</strong><input type=form id="form" placeholder="ユーザー名を入力してください" style="width: 250px"/></td></tr>
</table>
<table id="result" class="table table-hover table-bordered table-sm table-dark mb-3" style="width: 450px; margin-left: 55px" >
</table
```

```javascript
.done(function(data){ 
     $('#result').find('tr').remove(); 
     $(data).each(function(i, user){ 
     $('#result').append('<tr><td>'+ '◆：' + user.name + '</td></tr>') 
     });  
   }) 
} else { 
    ～省略～   
.done(function(){ //タグを消す方
     $('#result').find('tr').remove();   
})
```

★構造について  
⇒検索されたユーザーが分かりやすようにtableタグの中にapped()メソッドを使ってtrタグをとtdタグを入れるようにした。tableクラスの中にtableクラスをネストは出来ないので、検索窓用のtableタグと結果表示用のtableタグあり。trタグが増えると下に表示されていくのでそれでよい。

★cssについて  
⇒このファイルには、上にもう一つのメインtableがあるが、bootstrapのtableクラスを指定するには、tableという名前ではないといけないので、ユーザー検索のtableに関しては、直接タグの中にstyleを指定する

## 最終仕上げ

★read me確認  
⇒バージョンと簡単な使い方が書いてあれば。DEMOのgifファイルは欲しい。
⇒ライセンス確認（違反していないか）

★github関連  
⇒gitignoreに.envファイル（メーラー機能を使っているなら）とconfigのmaster.keyファイル（デフォルトでgitignoreにあり）
⇒pushする場合、リモートはpublicにすること（プライベートだと相手が見えない）

★partialできるか  
⇒render駆使

★seo対策

★cssの設定（画面のデザイン）  
⇒costom.scssにて

* bodyにfont-family一番好きなserifと崩れないためのオプション追加

* navbarにあるbg-ligthというので真っ白くなり、cssとかで色を指定しても変わらないので外す！navbarクラスにbackgroundで色付け
