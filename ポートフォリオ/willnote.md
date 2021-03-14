# willnote

★初期環境構築★  

* rails6でやるのでテックピットのやり方で導入（fontawesomeまで）
* todoの土台は、速習を基本（ｐ８２～ｐ１８２）
* 

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

③viewの編集
⇒準備のページの他の追加でNoteモデルの為にymlファイルを編集（ｐ１０１）  
⇒new,create,index,showの順で作っていく。  

* newアクション用のビューはform_withで作る

* indexアクション用のビュー
⇒`@notes = Note.all`で登録されたデータをtableタグと@notesで表示できるようにする
⇒i18nを設定していると`Model.human_attribute_name(attribute) メソッド`を使うことで、モデル名と属性名を透過的に参照できるようになる。データベースを引っ張りたいtbodyはeach～end文で挟みそこに@noteを使う
⇒mbはmargin-bottomの略。
⇒名称をshowへのリンクに変える箇所（`<%= note.name%>を<%= link_to note.name, note_path(note) %>に変える所`）では、link_toのキャプチャの部分をeach分のブロック変数のnameをそのまま使う

* showアクション用のビュー
⇒コントローラーのshowアクションでは、idでモデルオブジェクトのレコードをデータベースから検索。idで検索するのでfindで良い。showページでは、すでにあるデータをfindで引っ張り、@noteに入れて、ビューの＠noteから引きせるようにする。
⇒詳細に表示するデータを引っ張るときに.allの他にもfindとparams[:id]を使うことでそれだけを引き出せる
⇒urlのリクエストで"notes/1"の１というidを付けて、それをparams[:id]の[:id]に入れ、それを元にfindで検索をする。そのデータを表示したい、アクセスしようとする、している状態は一つ一つのデータにidがあるからそのidを取得して、＠noteに入れてビューで表示できるようにする。
つまり、作成するときは、.new。既にあるデータを表示するには、find(params[:id])。idを引っ張るだけでそのデータ全体が得られる（一意だから）params[:name]ではどのnameかわからない？
⇒ここではデータの取得についてeach~endを使わずそのまま取得している。
⇒showのビューページの　<td><%= simple_format(h(@note.memo1), {}, sanitize: false, wrapper_tag: "div") %></td>　については、ｐ１１３の説明がわかりやすい。memoには多くの文章や改行が入ることを想定して、型崩れしないようにするrailsのメソッド。

⑦編集ページとリンクとupdateとパーシャル
⇒indexビューファイルの編集ビューへのリンクは、ブロック変数が無いとルーティングエラーになる。showにおけるlink_toのパスはブロック変数を使ってないから引数要らない
⇒editとupdateアクションはセット。showと同じく元々あるデータから引っ張るから、find(params[:id])を使う。newファイルをそのまま更新するのだから、同じコードになりパーシャルが使える。
⇒パーシャルの関係上、submitのキャプチャはnilに、囲んでいるクラスの名前は揃える（notenewPageをnotePageに）
⇒パーシャルに関しては、テックピット方式で！（２－４）renderで指定するファイルにはアンダーバーは付けない


④redirect_toへのフラッシュメッセージｐ１０７
⇒layoutビューのif文はきちんとendで閉じるのを忘れない事！
⇒createのsubmitはi18より、キャプチャのところをnilにするとそのまま名前を入れてくれるのでnilにする。

⑧deleteの実装(テックピットを基本に)
⇒ルーティングでresourcesをしているのでルーティングは問題なし。コントローラーにdestroyを記載
⇒<%= link_to "削除", note, class: "btn btn-danger", method: :delete, data: {confirm: "#{note.name}を削除してよろしいですか？"} %>　の部分で、link_toのパスの部分はなくても大丈夫みたいだが、一応基本上にあるeachのブロック変数を持ってくるのがテンプレでありそう。また、編集と削除ボタンをくっつけるためにも、それぞれを<td>タグで挟むのではなく一緒にまとめて挟む。上の<th>タグの数とも数が揃う。注意なのが、showのページに同じdeleteリンクを入れるとき、式代入は@noteに変更する。indexでは、each文のブロック変数をそのまま使っていたのでnoteだけでもよかった。

⑨モデルに検証（バリデーション）をかけて、エラーメッセージが表示されるようにする（p140）    
⇒マイグレファイルでnameカラムをnull:  falseにして、Noteモデルファイルでvalidatesをnameにかけるが（presence:  true）、
これだけだと未入力の時、エラーになるがエラー表示されない。したがって、その表示が欲しいeditとnewのビューファイル（更新や保存するページ）の上にコードを書く。そして、これらは同じコードなので、パーシャルファイルに書くことになる。（テキストにはslimで書いてあるが、#はid=、- は<%になる。作ってある@noteオブジェクトにerrors.present?で検証エラーの有無を調べ、あればif文実行。ja.ymlのメッセージが出る）
⇒ここではform_withの上に記述しているので、上に出る？

⑩ログイン機能：ユーザーモデル作成（p149）（ここからやりたいのは、登録したユーザーがそのnoteデータを持っているという形）
★railsでは、コントローラーからsessionというメソッドを呼び出すことで、セッションにアクセスできる。cookiesに含まれるIDをセッションidとしてブラウザ側で保存、同じドメインにリクエストするときにも送り、サーバー側もそれを受け取り判断。
⇒セッションにデータを入れるには、
session[:user_id]  =  @user.id　値を取り出すには、  @user.id   =  session[:user_id]
（Useモデルのオブジェクトからidを呼び出して入れている。）
⇒先ず、モデルを作る
⇒rails g model User name:string email:string password_digest:string
⇒マイグレでemailのユニークの記述の仕方については、後ろにそのまま書くのではなく、indexという型を設けて改めて記述する必要があるのかも。もちろん、Userモデルのnameとemailにも検証をかけておく（presence:  true）

①password_digestカラム作成
②モデルにhas_secure_password設定、
⇒データベースにpasswordとpassword_confirmation属性が追加される
③gem  bcrypt(コメントアウトをはずす)⇒bundle忘れずに

⇒次に、usersテーブルにadminというカラム（属性）を追加するために
⇒rails g migration add_admin_to_users（マイグレファイルを追加）
⇒add_column :users, :admin, :boolean, default: false, null: false（usersテーブルにadminというカラムをboolean型で追加）


⑪新規登録画面に向けて（p155からは、テキスト通りに進めると、管理者がユーザーを登録するタイプのログインの仕方になってしまうため、ここでは普通にログイン画面が最初に表示され、新規登録画面にいき、登録できたら、ログインをして、ユーザー管理はadminがtrueになっているユーザーだけが見れるように実装するように進めていく！）
★つまり、普通にユーザーデータをつくり、その中の一人にadimn属性をつけて、管理者しか入れる場所を一般ユーザー用の場所を分ければよい。まず、ユーザーが登録してログインしないと使えないようにする。
★セッションで新規登録をやると、セッションにモデルが必要になるので、新規登録はusersコントローラーでつくる
⇒先ず、userコントローラーを作る、rails g controller users index  new(管理者は一覧を見れて、削除できれば良い)
⇒ルーティングは、必要なアクションをresourcesして、新規登録だけはログインにからむので、名前をregistrationに設定。
（アクションと繋がれば自由にurlを作れるので、"/registration"  to:  users#new　とスラッシュをつける）
⇒destroyアクションのリダイレクト先は、ユーザー一覧に戻るで設定。createのリダイレクトは後のログイン画面に飛ぶようにする。
⇒先ずビューでnewを作り、データべーズに保存できる形をつくり、indexを作って表示させる。その中に削除システムを作る。
⇒destroyからのパスは、そのままユーザー一覧に残ってくれていいので、users_pathでindexページを表示させる
（admin表示はデフォルトで無しにしているので後でコンソールで追加する）

★＝＝＝
[#<User id: 1, name: "島野俊希", email: "slimslim@au.com", password_digest: [FILTERED], created_at: "2020-12-02 04:25:34", updated_at: "2020-12-02 04:25:34", admin: false>]
このようにユーザー一覧で上に出てしまう（モデルの中身が出てしまう件は、、）
⇒https://qiita.com/superman9387/items/988fc11118a0f0c159fc
＝＝＝★

⑫ログイン機能（sessionコントローラー（認証機能を作る）ｐ１６１）
★sessionのルーティングについて、なぜかresourcesだとルーティングエラーになってしまうのでそれぞれルートを作る
⇒①ログインホーム（get:new）、ログインする（post:create）、ログアウト（delete:destroy）の実装
⇒コントローラーを作る、rails g controller sessions new、ルート設定で必要なアクションの記述（ｐ１６２でそれぞれget, post, deleteをきちんと設定）、コントローラーはdef newだけ書いてあれば表示されるので、先ずnewページ（ログインページを作る）。今回は、form_withの引数にscopeを使用、モデルが無いためymlに書いても適応されないので、labelの後ろに直接の日本語を明記。
⇒次に、入力されたemailとパスワードを使ったログインをするが、新規登録とは考え方が違う（DBにただ保存をするわけではない）
```
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
⇒まず、ストロングでemailとpasswordしか受け付けないようにする。find_byで入力されたemailと同じモノのemailでユーザーを探し、そのユーザーが持つパスワードが入力されたパスワードと一致するか（authenticateメソッド、ボッチ演算でnilのエラー防ぎ）確認して、if文がtrueなら、そのユーザーのidをセッションのidに格納（Evernoteの⑩にあり）
＃authenticateメソッドはhas_secure_passwordを記述すると使えるメソッド。ユーザーがいない時は、nilになるのでボッチ演算子
（つまり、ログイン状態というのは、session[:user_id]にidが入っているかどうか否かで実現している。これがログインしているの意味、裏を返せばidが入ってないという事は、ログインしてないということ。これで、session[:id]という属性を使って、消したり、見えなくしたり、表示されないようにしたり、idがnilならログインできないようにしたりできる）

＝＝上記をうけて＝＝（P164）
⇒session[:user_id]にidが入ったら、先ずデータの取得のやり方はとして、User.find_by(id:  session[:user_id])という形で取得できる。
＃idで検索するならfindでも良さそうだが、、重要なので下記を見る。
（他細かい事情はｐ１６４の下の＃になぜid検索ならfindではないのかとか書いてあるので目を通す）
⇒これを使い、current_userメソッドをつくる（どのページでも使いたいので共通コントローラーに作る）」
```
　helper_method :current_user　(全てのコントローラーに適応)

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
```
⇒先ず、ヘルパーメソッドとして使えるようにして（全てのコントローラーから使える）、実際の定義は、@current_userという変数に何かが入っているならそのまま、入ってないなら、find_byで見つけて入れる（ifの後ろはsession[:id]にidがあれば）これで、セッションidを維持できるようになる。ログアウトでは、current_userメソッドが全コントローラーで使えるので、destroyで使う。ただし、session.delete(:user_id)だけだとユーザーに紐づく情報までは消せないので、railsにあるreset_sessionというメソッドを使う。重要なのは、これらのメソッドを使ってコントローラーのdestroyにどのような指示を書くか？（何をdestroyするのか⇒session[:id]をnilにする。ログアウトしたら、ログインページへ飛ぶのが普通なので、リダイレクト先はログインページ）

～ナビゲーションバーの実装とルーティングの整理（current_userをどう使うか）～
●上に共通にナビバーを作りたい。記述場所は、レイアウトビューでコンテナの中に書かなくてよい。<nav>タグではさみ、そのタグにnavクラスをつける。ulタグにもnavbarクラスを付けて,特にml-autoが重要！current_userのif文で分岐させ、セッションidが入っていれば表示するしないを書く。link_toのパスはそのままプレフィックスを使う。そして、そこにログアウトも入れる。
●下記のコード（テックピット参考）は、curret_userが使えるなら出来るレイアウト。ログイン中のみの表示にしたいので、if文のcurrent_userの下のナビに添える。ただし、レイアウトをそろえるためにclassをnav-itemにすること！
```
<li class="nav-link"><%= current_user.name %>さん</li>
```

⑬ログインしないとtodo機能が使えない設定（before_action　コントローラーのフィルタの設定)
★ログインしないとnoteページは入れないけど、新規登録画面はいけるようにする
★そのためのlinkを貼る
⇒「ログインしていないと」という制約を実装するには、一つ考え方でコントローラーのアクションを起こす前に、共通コントローラーでbefofeをかけるという手がある。テキストでは、共通コントローラーに記述していたが、今回usersコントローラーの新規登録は制約はかけたくない為、それぞれのコントローラーにbeforeとそのメソッドの制約をonlyを使って記述。（usersのnewとcreateは新規登録だから制約をかけない）
```
def login_required #カレントユーザーがtrueではない（ログインしていない）ユーザーは強制でログイン画面へ
    redirect_to login_path unless current_user
  end

これを一番上にbeforeでかける
●notesコントローラーは全てかける。（ログインしてcurrent_user　session[:id]に値が入れば使える）
●usersコントローラーは、indexとdestroyのみ（newとcreateは新規登録させなきゃいけないから）
●sessionsコントローラーは、かけない（ログイン画面の表示もログアウトの表示や命令もログイン前）
```
⇒他の画面に飛ばない確認ができたら、ログイン画面に新規登録のリンクを貼る（見栄えを考え、btn btnとmb-4の調整とawesome使用する。他に前のページの戻るボタンも追加）

⑭アソシエーション（ｐ１６９ではここでマイグレにreferences型を追加している）
★ログインしているユーザーにそのユーザー自身のタスクデータだけを管理できるようにさせたい
（UserモデルとTaskを紐づける。具体的には、notesテーブルにuser_idカラムを付加する）
★テックピットでもあったストロングのmergeもnoteコントローラーでやる
⇒ここで追加するぐらいならrollbackしてreferencesを追加しようと思ったが、マイグレをロールバックしてreferences型を加えた後、migrateすると、userテーブルが無いと言われる。これは、先にnoteテーブルを作っているからであり、migrateの順番を変えて先にuserのファイルをやるという手もあるらしいが、それはあくまでローカルのみで、本番では日付順でマイグレートするらしい。結果、先にnoteファイルを作ってしまったので、addtoでreferences型を追加する方が賢明である。ということで、references型を追加する。
⇒rails g migration AddUserIdToNotes（ファイルのexecuteは後から追加するのだからしょうがない。後で、コンソールでNote.allで調べてみると確かに全て消えている。sqlだから、シングルコーテ）
⇒ここでは、、add_reference :notes, :user, null: false, index: true
（既存のテーブルにリファレンスを追加ということでnotesテーブルにUserモデルに紐づくuser_idを追加し、indexもつける。ただ、foreign_keyは使ってない）
⇒次にNoteモデルにbelongs_to: user  Userモデルにhas_many: notes
⇒ここでこの定義をすることにより、以下のメソッドが使える。
●user.notes
（Userクラスのインスタンスから紐づいたNoteオブジェクト一覧を得られる。これは、ログイン状態でcurrent_userメソッドがtrueな時は、current_user.notesでも得られる！user.notesと同じことになる）
●note.user(タスクにおいてユーザーは一人しかいないから単数形？NoteクラスのインスタンスからUserオブジェクトを得られる)
●noteのインデックスにnote.allだと全てのユーザーのタスクがでてしまうが、@notes = current_user.notesで今のユーザーのオブジェクトを！という指定ができる
●関連とreferencesを設定してuser_idがnullがfalseで設定するとそのuser_idが入ってないと登録できない。テックピットだと
```
merge(user: current_user)
```
がないとエラーになる。
⇒つまり、これからのデータがuser_idが入ったデータじゃないとエラーになるので、createやupdate時にcurrent_userなどを使ってデータを作成しないといけない。

☆アソシエーションのよるリファクタリング（ｐ１７２）
＃テックピットだとコントローラーのストロングパラメーターでmergeを使ってuser_idを入れていただけ。これでもいいが、他のユーザーがurlに他のidを打ってそれがヒットしてしまった場合そのページが出てしまう。（User.allなど）よって、そのページをコントローラーでcurrent_userからそのタスクを作ったり（new、create）、表示したり（index）、検索したり（edit、update、destroy、show）すると、そのユーザーのタスクだけを扱うシステムにできる。よって、コントローラーのそれぞれのアクションをcurrent_userと関連を使って表記する。
#referencesでuser_idが入ってないnoteデータはnullがfalseになっているので途中で追加する場合、db:resetするかexecuteをする。そして、コントローラーにuser_idを入れるためのコードを記述しなくてはいけない。newは変更なし。
●create
⇒@note = current_user.notes.new(note_params)
(テックピットはストロングパラメーターにmergeを、速習でこのcreateにmergeを記述する方法が書いてあるがアソシエーションを使う。ここで、ただのnoteデータを作るのではなく、今ログインしているcurrent_userを巻き込んでuser_idを一緒に登録する。)
●index
⇒@notes = current_user.notes
（Note.allだと全てのユーザーのnoteデータが出てしまうのでcurrent_userで検索する）
●show,edit,update,destroy
⇒@note = current_user.notes.find(:params[:id])
（findなので、Note.find(params[:id])だけだとid検索をして他のユーザーにidがヒットしてしまう可能性があるので、current_userのみ検索出来るようにする）
⇒ここでは、四つ分同じコードがあるのでbefore_actionでリファクタリングする
●最後にコントローラーのbefore_actionに.admin?を付け足して、adminしか見られないようにする
⇒ユーザー一覧（アプリレイアウトにあり）をif current_user.adminで挟む
⇒ユーザーの削除や一覧表示はadminのみにする。今回の新規登録は（userコントローラーのnew,create）一般ユーザーもOKなので、indexとdestroyのみに追加でbefore_actionとそのメソッドにadmin？を付ける。そうすると、今adminユーザーが居ないので、コンソールで作る
●あとは、一応noteデータの表示順を安定させる為に、noteコントローラーのindexにorderを付ける（つけないと表示が不安定になるらしい）

⑮javascriptとプラスアルファ
⇒まず、☆https://techtechmedia.com/jquery-webpacker-rails/（jqueryの導入）
（この通りにやって検証のconsoleにok出た！最初のwebpackの所はちょっと中身が違うがそのままでok）
⇒本で基礎固め
●『javascript超入門』
●『javascriptレシピ集』の基礎ｐ２０８まで
●rails6での開発を軸とする。目の前のモノを消化し、遠くのモノを触って迷子にならない。
⇒techpitのコースのカスタマイズ

★ユーザーの名前とアドレス変更は、出来るようにしておく
①ルーティングのusersにeditとupdate付与
②コントローラーedit、update編集（updateメソッドは途中引数が必要）、これはadminだけではなく一般ユーザー出来るようにするので別途beforeを設ける（current_userのみ）。データの引っ張りはアソシエのcurrent_userは使わなくていいと思う
③viewにeditを作り、newビューのパスワード以外をコピーし、一応タグのクラス名をちゃんと変える（userProfilePage）
④ナビバーの名前をクリックすると飛べるようにlink_toを～さんの所へ
#注意#link_toのパスを普通にedit_user_pathにするとno match routeと出てしまう。パスの引数に（curren_user）を付けるとOK
だった。link_toを貼る前にurlに直接接続したときに/users/1/editと入ったが、おそらくedit_pathだけでは1の部分が取得できなかった為と思われるので、引数を付けたらうまくいったのはそういうことかもしれない。




⑯管理人ブログの作成(投稿機能)
⇒最初に、javascript内にimagesフォルダーを作り、ダウンロードした画像を入れる、次にconfigのwebpacker.ymlのresolvedにそのパスを入れる（２－１）
（管理者用のナビバーは必要ないかも。ヘッダーがあり、ドロアーがあれば中身は投稿機能でいいので、テックピットは最初のimagesの処理以外は実際は５－１からで良い。しかもユーザーテーブルはすでにあるのでER図はreferences型を使える。中身の投稿ページができたら通常のナビバーを整理する）

●ER図
postsテーブル
photosテーブル
	- caption(string)
	- user_id(references  null無し)
	- image(string  null無し)
	- post_id(references  null無し)
Postモデル
Photeモデル
	- validates :
	- validates :image, presence: true
⇒モデル作成、ER図通りに設定して、migrate。
⇒UserモデルにPostモデルへのアソシエ。PostモデルとPhotoモデルのアソシエ（has_manyのdependent: :destroyを忘れずに）

★carrierwaveとMinimagickの導入
⇒gem 'carrierwave',  '~> 2.0'を追加して、bundle installをやるとminimagickも一緒に追加された？
⇒先ほど作成した、imageカラムに紐づくuploaderを作成（rails g uploader image）
（ここでappの中にImageUploaderファイルができるので覚えておく。）
⇒さらに、imageカラムをアップローダーに紐づけ。上のアップローダーのクラスをPhotoモデルのimage属性に紐づけする。
★Minimagickを使うためには、imageMagickをOSに（環境に）インストールしなくてはいけない。
（環境にインストールするという事は、自分の場合Linuxのubuntuを使っているので、windowsにインストールするというよりも環境であるubuntuにインストールする。よって、ubuntuでのインストール方法でやる）
いきなり、sudo apt install imagemagickをやるとエラーになる。（最初インストールに時間」かかる１５分くらい）
⇒まず、sudo apt-get update
⇒次に、sudo apt install imagemagick
⇒インストールされているか確認　convert -version　
⇒これで　Version: ImageMagick 6.9.10-23 Q16 x86_64 20190101 https://imagemagick.org　と出てくればOK！先ほどMini_magickが一緒にインストールされていたが、一応、gemにmini_magickを追加して、bundle install。
⇒アップローダーファイルを修正する（５－２）

⑰投稿機能のページ（postとphoto）
★ここではデータの保存という観点で、データをcreateする時に、容器（postデータ）を作成し、さらに同時にその容器に画像を保存するという流れになるので、関連付けをした後、コントローラーのnewでは、postデータの取得と同時にphotoのデータの取得。createでは、postを保存すると同時にphotoのimageデータを入れる処理。viewには、photoを持ってくる処理を記載する。
＃postsはnewとcreateのみ、photoはcreateのみのアクションを作る
⇒ルーティングでは、urlにpostの所有するidを含めてphotoにアクションを渡すために、ネストするか、　post '/posts/:post_id/photos',  to: 'photo#create', as: 'post_photos'と全て記載し、asで名前も変更していく方法があるが、ネストがわかりやすいのでその方法をとる。ネストするとルーティングを見ると、ちゃんとurlにpost_idが挟まっている。
⇒postsコントローラー作成（rails g controller posts)
⇒コントローラーの編集（new  creare  ストロングパラメーター）
●newアクションでは、関連付けの慣習でプラスで@post.photos.buildを付ける。buildはnewと同じくインスタンスを作り、関連付けした時に付ける。
●ストロングパラメーターは、mergeを使わず、createの.newでcurrent_userを付けて追加する。今回、、postとphotoを同時に保存していくという流れで、photosテーブルのimageもpermitに含めるため　photos_attributes: [:image]　という記載も入れる。
●createは、ifの後にすぐsaveではなく、@postにphotosデータが入ったかどうかの確認を入れる。（@post.photos.present?）
●postとphotoのもう一つ関連付け（accepts_nested_attributes_for）
⇒accepts_nested_attributes_forは、親子関係のある関連モデル(今回でいうとPostモデルとPhotoモデル）で、親から子を作成したり保存するときに使います。
今回投稿する際にPostモデルの子に値するPhotoモデルを通して、photosテーブルに写真を保存します。accepts_nested_attributes_forメソッドを親のモデル（Postモデル）に追加する必要がある。
⇒今回、投稿の画像はpostsテーブルではなくphotosテーブルに保存します。その際は、fields_for を使うのですが、fields_for の場合、コントローラーには、photos_attributesを。モデルには、accepts_nested_attributes_for を記載する必要があります。（postを使ってphotoにデータを入れる流れ）

⇒ビューの作成（newビュー）きちんとdivで専用に囲い、ナビバーとの距離、投稿ボタンの距離を考えて、classにmb-4を入れる。fields_forで子モデル（photo）に変更を加えられる。出来たら、保存できるか確認をして、コンソールでuser_idが入っているか確認。
⇒gifは重くて保存できない？gitにおけるオプションあり（５－３）

⑱投稿ページを表示させる
⇒引き続きpostコントローラーを使っていく。ルーティングのpostsにindexを増やし、コントローラーでindexアクションを作る
（変数は複数形（@posts）、表示させるデータを１０個までにするためlimit(10)を。さらに、n+1問題の処理のためにincludedsを挟む）
★indexビューを作成
◍ここではcarrierwaveとMinimagickで導入した、アップローダーを適応している（medium）
⇒https://qiita.com/Inp/items/cc447237e23bf10d159e（carrierwaveの使い方）
⇒ここではMinimagickは使ってない。そして、下記のimageの後を.to_sにすると、それぞれの画像の大きさで投稿画像が表示される。
ここアップローダーファイルのmeidumを使うとそれぞれの画像をその一定の大きさで表示してくれる。
アップローダーファイルのmedium~do~の（　）内の数字は、画像が投稿された（保存された）時に効果があり、（300, 300なら）このサイズでリサイズされ保存されるので、表示画面が広いと画像も荒くなる。つまり、（1080, 1080）ならこのサイズで保存され、画面の幅や高さとの調整になる
```
<%= image_tag post.photos.first.image.url(:medium), class: "card-img-top" %>
```
ｈ

●グリッドシステムを使って、画像のエリアを真ん中に固定。名前とキャプションがくっ付いているので、キャプションのspanのクラスにml-2
●bootstrap以外のクラス名は出来るだけスネークで記述、機能はハイフンで。
●cssは、画像のインポートは、下記の準備によりできている
configのwebpacker.yml
```
resolved_paths: ['app/javascript/images', 'app/assets/images']　追加
```
●ここで、postコントローラーのリダイレクト先をこの投稿画面に変更(posts_pathに変更)

⑲管理者用のナビバー作成と投稿ページ仕上げ
★通常のナビバーをそのまま流用。（左にブログ名と右に後で作るドロアー用のスペースとnoteホーム画面に戻るリンクを）
⇒一応admin専用で投稿機能のリンクを貼っておく
★note機能のみに通常ナビバーを出すようにパーシャルを別に作る（noteアプリとユーザー管理などを全てナビバーパーシャルとコンテナクラスを分ける）
★noteアプリの通常ナビバーに管理人ブログへのリンクを貼る
⇒投稿ページの修正に関しては、一部枠の関係で入れなくてもよい要素を抜いたdivタグがある。これが抜けるとバランスが崩れるので入れておく。bootstrapを使ったheaderとbodyがレイアウトで重要。下にlink_toのバック機能を入れておいた（bootstrapを利かすためにdivに入れる。）
⇒途中で使う、f.field_forを使ってphotoのカラムを追加するためには、コントローラーのphotoのimageの追加とpostモデルへのaccepts_nested_attributes_forメソッドが必要

⑳ブログの詳細ページと削除ボタンの実装
⇒引き続きpostコントローラーを修正していく。ルーティングにshowを追加。showアクションをfind_by(id: params[:id])で追記。
次にshowビューを作成。
★ここでビューを途中で書いて、経過を見ようと直接urlに飛ぶとimage_tagにnilが入っているのでエラーと出る。これは、コントローラーでfind_byでidを探しているが、直接だと何の投稿画像ページかをidで調べられないためにアクセスできない。後の、indexページから詳細に飛ぶリンクを引数を付けてshowページに繋ぐことでidを元に検索が出来るようになる。（アソシエ、外部キ゚ーの機能上しかたがない）
●最初に真ん中寄せに全体をして、その中でさらに中を８：４に分ける（class="col-md-8"）因みにここを１２にすれば、上記の真ん中寄せの状態の中でいっぱいに横に広がる。つまり、反対側（ここなら残りの４分）を広くしたいなら左を６にして、右を６にすればいい。
●cssの.post-user-nameの記述いらない
⇒微妙にnameと時間表示が位置がずれるので、位置調整のためそれぞれのクラスにml-2を置く。
⇒次にに、indexの画像から詳細ページと時間表示から飛べるようにする。
（要素や画像をリンクにするには、doの構文で挟む）
⇒最後に削除ボタンの作成。ルーティングとコントローラーを記述。destroyアクションに
```
@post.user == current_user
```
を付けておけば、そのユーザー自身しか削除できなくなる
⇒ビューは一応showページに下に設置しておく。if  current_user.admin?～endで挟んでおく

★ここで他のユーザーになって管理人ブログを閲覧するとcurrent_userでデータを取得しているので画像が表示されない
⇒postコントローラーでcurrent_userでデータを取得すると、他のユーザーにはそのデータが表示されないので見ることが出来ない。indexとshowアクションにPost.allを付ければ閲覧可能になる。
★ここでUser.find(1).posts~と書いて直接管理者を指定もできるが、コントローラーにべた書きはいけない。ここでは、管理者が二人ならとか、一般ユーザーも投稿できる時はなどによってコントローラーの書き方が変わってくる。
```
変更前は、@posts = current_user.posts.limit~
def index
  @posts = Post.all.limit(10).includes(:photos, :user).order(created_at: :desc)
end
```

```
変更前は、@post = current_user.posts.find_by(params[:id])
def show
      @post = User.find(1).posts.find_by(id: params[:id])
   end
```
https://qiita.com/tono0123/items/576a4a4659b51860f304(参考：モデル検索)


㉑いいね機能の実装
⇒いいねデータには誰のいいねで、どの投稿なのかという2つのデータを持たせる。それ以外はそれ自身が何か表示するわけではないので保持するカラムは2種類のみになる
likesテーブル
commentsテーブル
	- post_id（references　null無し）
	- user_id（references　null無し）
	- comment （text　null無し）
	- post_id（references　null無し）
	- user_id（references　null無し）
Likeモデル
Commentモデル
	- belongs_to  :user
	- belongs_to  :post
	- validates :user_id, uniqueness: { scope: :@post_id}
	- belongs_to  :user
	- belongs_to  :post
⇒モデル作成（Likeモデル）とreferences設定、migrate
⇒アソシエ設定
●Userにhas_many 　Likeにbelongs_to
●一つの投稿は複数のいいねを持てる（has_manyとdependentとorderを記述）
●いいね（id:１）idは一つの投稿(post)に一つのみ（belong_to）
⇒Likeモデルの検証記述。持っているuser_idに対してuniquenessを付けることで同じidのいいねが登録されないようにする（一回しかいいね出来ない）
⇒likesコントローラーの作成、ルーティング（resources: createとdestroyでpostの中にネストする）
⇒likesコントローラーについて
●createアクション
⇒インスタンス作成時にはnewではなくbuildを使う（関連付けの慣習）
⇒どのpostにいいねを押したかのpost_idを変更できるようにストロングパラメーターにpost_idのみをつける（permitは変更できるキー指定する）因みにcurrent_userでbuildしているのでuser_idも入っており、その後、@like.post（逆アソシエメソッド）でpost_idも入れている。
★likeデータが生まれる＝そのlikeデータはそれぞれidを持っている。しかも、それはlink_toでハートマークをクリックした時に生成され、likeデータはpost_idカラムと、user_idカラムを持っており、さらにそれらのidを入れてlikeデータを作る。
⇒respond_toメソッドは、レスポンスのフォーマットを切り替える。リアルタイムで変化を付けるためにjsファイルを対象にする
⇒先ず、current_user.likes.build(like_params)で現在操作しているuser_idも含めたインスタンスを作り、@likeに格納。それとは別に、@likeはアソシエメソッドでpostのデータも引き出せるので逆アソシエ（@like.post：@likeはLikeの情報を持っているので）でpostのデータを@postに入れビューで使えるようにしておく。（@postはどの投稿にいいねを押したのかを判断するためにビューで使う：重要なのは、この@postを作っているのはlikesコントローラーであり、Likeデータをcreateする時に、Postのデータが必要であるという事）
⇒次に、本来ならredirect_toでページを読むところを、リアルタイムでビューを反映させるためにsaveされたら、javascriptのファイルへ飛ぶようにする。（respond_to: js）
◍respond_to :jsはlikeデータがcreateされたら、link_toのフォーマットをｊｓ形式結果を出すようにするためのコード。ビューにあるlink_toのcreateのコードをjsファイルに同じコード書くことで、ビューにあるコードがｊｓ形式でリアルタイムに動く。ビューに書いてあるコードをjsファイルに同じコードを書いてｊｓ形式で読み込む。
⓪ユーザーがハートをクリック　
①liked_byでidの存在を確認し、無いならlink_toでcreateアクションへ　
②ハートデータがsave　
③jsファイルへ飛びjsファイル発動　
④画面が変わる

●destroyアクション
⇒ここでは、いつものLike.find_by(id: params[:id])で取得する。そしてここでも、@postにPostデータを取得しておく。そして、消し方もrespond_to :jsでjsファイルへ

～postoindexビューへ～
★まず準備でpostモデルにliked_byというオリジナルメソッドを追加する。ここでindexビュー側でcurrent_userの引数をもらってuser_idとpost_idを元にLikeデータを検索する。
```
def liked_by(user) 
   Like.find_by(user_id: user.id, post_id: id) # user_idとpost_idが一致するlikeを検索する
end
```
◍likeデータが存在するか、しないかでcreateかdestroyにするか分岐させるために必要なオリジナルメソッド
◍likeデータを消すには、その消すlikeデータのuser_idカラムとpost_idカラムが分からないと消せない。ビューでこのメソッドの引数にcurrent_userを入れてcurrent_user.idでuserのidを取得。二つのidで検索をかけるの、user_idだけだとそのユーザーの複数のデータが出てくるので、user_idとpost_idと二つのid検索で、検索データを１に絞っている。likeデータを押すとそのデータを消せるのはもちろんcurrent_user本人なので、そのユーザーかどうかをcurrent_userで取得している。そのユーザーのいいねしたpost_Idが分かれば、どのlikeデータを指しているか分かり、そこにもしlikeデータがあれば、、、
<% if post.liked_by(current_user).present? %>はtrueになり、destroyアクションへ導く。無ければ、elseでcreateアクションへ
★postindexビュー
```
<div id="like-icon-post-<%= post.id.to_s %>"> 
  <% if post.liked_by(current_user).present? %> 
     <%= link_to "いいねを取り消す", post_like_path(post.id, post.liked_by(current_user)), method: :DELETE, remote: true, class: "loved hide-text" %> 
  <% else %> 
     <%= link_to "いいね", post_likes_path(post), method: :POST, remote: true, class: "love hide-text" %> 
  <% end %> 
</div>
```
◍divでは、そのクリックしたpostのidを取得できるようにid名をERBで指定。そうしないとどのPostデータに動きを起こすのか指定できない
◍likeデータが存在した場合、どのlikeデータを消すかを絞るために、use_idとpost_idを引数で渡す。これで絞れるので消せる。remote :trueにしないとjsファイルに飛ばない。
（local: trueはjs形式ではなくhtml形式で動かすことになってしまう。）
◍link_toでアクションに飛ばすので、method: を指定。class: lovedにcssを指定すれば、消された時の画像などに変更できたりする。

```
<div id="like-text-post-<%= post.id.to_s %>"> 
  <%= render "like_text", { likes: post.likes } %> 
</div>
```
◍ここでもcreateアクションとdestroyに続くjsファイルでここを表示するコードがある。
⇒その非同期では、likeデータと共に_like.textビューファイルを表示するようにしている。さらにそのファイルに渡す変数をpost.likesのアソシエデータをlikesという変数にして送ると指定している。
◍_like.text.html.erb
```
<strong> #likesはrenderメソッドの変数指定でpost.likesのデータが入っている
  <% likes.each.with_index do |like, index| %> 
    <% if likes.size == 1 %> 
      <%= like.user.name %> </strong> が「いいね！」しました 
    <% elsif like == likes.last %> 
      </strong>and<strong> 
      <%= + like.user.name %></strong> が「いいね！」しました 
    <% elsif index > 1 %> 
      </strong><%= "and " + (likes.size-index).to_s + " 他 " %> が「いいね！」しました 
      <% break %> 
    <% elsif index == likes.size-2 || index == 1 %> 
      <%= like.user.name %> 
    <% else %> 
      <%= like.user.name + ", " %> 
    <% end %> 
  <% end %> 
</strong>
```
◍

★最後にアクション後のjsファイルへ
```
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいねを取り消す", post_like_path(@post.id, @like), method: :DELETE, remote: true, class: "loved hide-text" %>'); 
$('#like-text-post-<%= @post.id.to_s %>'). 
  html('<%= j render "posts/like_text", { likes: @post.likes } %>');
```
◍ドルメソッドでアイコン全体の要素を取得。それに、jqueryのhtml()メソッドで中身を入れる（入れ替える、変更する、丸々取り換える）のだが、ここでは、、、
⇒このjsファイルではビューにあるコードと同じコードが書いてある。なので、ビューに書いてあるだけでは、html形式でページを更新しないと変化しないが、そのビューのコードをjsファイルのjs形式で起こしていると考えてみる。
⇒ビューのコードをjs形式で起こすなら、その起こしたいビューのコードをjsファイルで取得して起こしてやればいい
◍ここで@postと書いてあるが、コントローラーのcreateアクションとdestroyアクションで@post  = @like.postと入れていたので、この変数が取れる。この変数を使って、ビューと同じコードをhtml()メソッドに入れる

★いいねカウンター
https://techtechmedia.com/favorite-function-rails/
（このページでヒントを見つけた）
◍先ず、いいねの数（likeデータ）を取得するには、色々やり方があるが、きちんとアソシエが出来ていれば、
```
<%= post.likes.count %>
```
をそのアソシエメソッドが使えるビュー、つまり、コントローラーで@postやeach文でのpostを使えるビューで書けば、Likeのデータ数がcountメソッドで取れる。
で、、、、、、、、
これをリアルタイムに変えるには先ほどの流れで、
①ビューにコードを書く
②ビューのコードを取得して同じコードを書いたjsファイルを用意
⇒この数字は、createで増えて、destroyで減るのでいいね機能のビューのlink_toと一緒に並べれば、あとはそのコードをjsファイルのhtml()メソッドに一緒に含めれば非同期にできる。jsファイルでは変数を@postにすることを忘れずに。
```
<div id="like-icon-post-<%= post.id.to_s %>"> 
                  <% if post.liked_by(current_user).present? %> 
                    <%= link_to "いいねを取り消す", post_like_path(post.id, post.liked_by(current_user)), method: :DELETE, remote: true, class: "loved hide-text" %> 
                    <span class="likecount"><%= post.likes.count %></span> 
                  <% else %> 
                    <%= link_to "いいね", post_likes_path(post), method: :POST, remote: true, class: "love hide-text" %> 
                    <span class="likecount"><%= post.likes.count %></span> 
                  <% end %> 
                </div>


★create.js.erb★
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいねを取り消す", post_like_path(@post.id, @like), method: :DELETE, remote: true, class: "loved hide-text" %><%= @post.likes.count %>'); 
$('#like-text-post-<%= @post.id.to_s %>'). 
  html('<%= j render "posts/like_text", { likes: @post.likes } %>');

＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
★desroy.js.erb★
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいね", post_likes_path(@post), method: :POST, remote: true, class: "love hide-text" %><%= @post.likes.count %>'); 
$('#like-text-post-<%= @post.id.to_s %>'). 
  html('<%= j render "posts/like_text", { likes: @post.likes } %>');
```
◍消したり、付けたりの関係なので同じコードをcreateとdestroy両方に書く。
◍htmlの加え方で、、ERBは～％＞＜％＝～   とコンマなしでそのまま続けられるらしいので、ビューでも、html()メソッドの（）内でもそのままくっ付けて書く。
★いいねカウンターの位置
🔺ハマり：ハートをクリックするとcssの適応がなくなってしまう（位置がずれる）
★解決：
⇒viewコードにあるハートのリンクを押すと、コントローラーがjsファイルに飛ばして、jsファイルのコードが発動する。
⇒jsファイルのコードにあるjqueryのhtml()メソッドがカギであり、このメソッドの取得した場所（<div id="like-icon-post-<%= post.id.to_s %>">）の中に、タグごとや（<p>test</p>）erbテンプレート（<%=~~%>）を丸ごと追加できるという機能がある。つまり、jsファイルでは、表示する場所（<div id="like-icon-post-<%= post.id.to_s %>">）にhtml()メソッドで中身をviewコードの挿入するという考え方になる。
要は、リンクをクリックしたときに、jsファイルのコードが出力されるわけだから、jsファイルのhtml()メソッドの中に、cssのクラスを含んだタグを入れてあげればいい。
```
$('#like-icon-post-<%= @post.id.to_s %>'). 
  html('<%= link_to "いいね", post_likes_path(@post), method: :POST, remote: true, class: "love hide-text" %><span id="likecount"><%= @post.likes.count %></span>');
```
⇒因みに、html()メソッドの中に<p>test</p>と入れるとハートをクリックすると一緒に出現する。

★indexビューのCSSとbootstrap
①組み立てとしては、グリッドシステムで場所を特定する。
```
<div class="col-md-6 col-md-2 mx-auto">
```
②次にcardというdivをcard-wrapで包んで、cardクラスの中にheaderとbodyを作る。
⇒このcard-headerとcard-bodyはきちんとその名前だけで位置調整がされている！header部分とbodyの区域をよく考えてコードを書くこと
③この組み立てでは、

㉒コメントの実装
⇒このデータの紐づきは、いいね機能にコメントを書くデータを付け足したものなので、詳細は上のいいね機能のER図にまとめて書く
⇒モデル作成、referencesとcommentカラム追加、migrate。
⇒userとcomment、postとcommentのアソシエ
⇒commentsコントローラーを作る。ルーティングはcreateをdestroy作り、postルーティングの中にネストする
⇒createアクション
●こちらは、普通に.newでデータを取り、ストロングパラメーターも普通に入れる。ただし、いいねと同じように途中@postに値を入れる。そして、jsファイルに繋げる。（respond_to:コメントを押したら、リアルタイムでビューを反映させるためにフォーマットをJS形式でレスポンスを返す）
⇒destroyアクションはいいねとあまり変わらないが、最初のコードは普通

★postビューへ
①postのindex.html.erbに記述
```
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
```
◍最初のコードは、id="comment-post-<%= post.id.to_s %>"で作成されていくpostのidを取得。to_sでクラス名に入れていく。
◍renderはindex用とshow用のパーシャルであり、ここではindexファイルのブロック変数のpostをpostとして渡している。実際には、ここのrenderの部分にcomment_listファイルのコードが出力される（ここにコメントで打ち込まれた文字が入る）

②パーシャルファイルの_comment_list.html.erbを作成し、記述。
```
<% post.comments.each do |comment| %> 
  <div class="mb-2"> 
    <span><strong><%= comment.user.name %>：</strong><%= comment.comment %></span> 
    <% if comment.user == current_user %> 
      <%= link_to "", post_comment_path(post.id, comment), method: :delete, remote: true, class: "delete-comment" %>   
    <% end %> 
  </div> 
<% end %>
```
◍ここのコードが丸々indexとshowファイルにrenderされている。
◍今ログインしているユーザーがコメントしたユーザーなら、入力されたコメントの横に✖をつけて、それをデリートボタンにする。

③app/vies/comments/create.js.erbファイルの作成
```
#create
$('#comment-post-<%= @post.id.to_s %>'). 
  html('<%= j render "posts/comment_list", { post: @post } %>'); 
$('#comment-form-post-<%= @post.id.to_s %> #comment_comment').val("");

=======================================================================
#destroy
$('#comment-post-<%= @post.id.to_s %>').
  html('<%= j render "posts/comment_list", { post: @post } %>');
```
★重要：ここで整理！indexファイルは、listファイルをrenderし、ここのjsファイルは自身にlistファイルをrenderしている。つまり、erbとhtmlのコードをjsファイルにrenderしている。そこにぶつからないようにコーテーションなどをエスケープしてjsファイルに適応されるように、renderの頭に「ｊ」をつけている。
◍ jメソッド： ActionView::Helpers::JavaScriptHelper#escape_javascriptのエイリアスメソッド。改行コード、シングルクオート、ダブルクオートをJavaScript用にエスケープしてくれるヘルパメソッド（のエイリアス）erb が Ruby コードとして解釈した文字列をJavaScriptで正しく扱えるようにエスケープしてくれる。
◍val()メソッドはvalueの中身を変更したり、取得するメソッドで、コメントを消す為に空欄をいれる
⇒コントローラーは、上記のlistファイルをrenderしたjsファイルに繋げている。



④postのindex.html.erb
```
<div class="row actions" id="comment-form-post-<%= post.id.to_s %>">  
  <%= form_with model: [post, Comment.new], class: "w-100" do |f| %>  
    <%= f.hidden_field :user_id, value: current_user.id %>  
    <%= f.hidden_field :post_id, value: post.id %>  
    <%= f.text_field :comment, class: "form-control comment-input border-1", placeholder: "20文字以内でコメント...", autocomplete: :off %> 
    <%= f.submit "コメントする", class: "send-comment" %> 
  <% end %>  
</div>
```
★重要：このform_withは、、postのビューコードなのに、Commentモデルのカラムが使われている（f.text_field :comment）。コメントコントローラーのビューでは@commentにpost情報を入れているが、もちろんpostコントローラーではcomment変数は作ってない。postビューでアソシエも踏まえ（post_idとcomment_idとuser_idで特定）commentカラムにデータを保存をする方法として。
⇒普通のベタな考えなら、postのindexビューはpostコントローラーのindexアクションと繋がっているので、postコントローラーのindexアクションに@comment = Comment.newを記述して、postindexビューでルーティングがネストしている時の考え方でmodel: [@post（ブロック変数ならpost）, @comment]で実装できる。
⇒ただこの書き方ではなく、直接form_withのmodel引数に.newの形でインスタンスを作る記述が使えるみたい。
◍submitのコードは付けなくてもエンターでコメントを送れるようになっているが、分かりにくいので追加。cssも施した。

★最後に、、
⇒コメントでも一回しかコメント出来ないようにCommentモデルにいいね機能と同じく下記のコードを記述。
（validates :user_id, uniqueness: { scope: :post_id }）
⇒また、空欄記入や多すぎるコメントを避けるためにcommetカラムにpresenceとlengthの検証をかける
⇒他のコントローラーにlogin_requiredを付ける(sessionコントローラーはdestroyだけ付ける)
⇒postindexビューで時間表示が被っている所があるので一か所消す。（time_ago_in_wordsの所）
⇒コメントされた欄といいね表示の間に線引きないので<hr>で間を作る
⇒投稿者の横にわざわざ画像のキャプションは要らないのでコード削除、それより投稿主の名前の横に時間が表示される方がいいので、投稿主の横に時間表示のコードをつける（これでコメントの場所といいねの場所がコード的にも整理できる）。そして、投稿主をfonsawesameで囲む(両側に付けるとうまく間を取ってくれる)
⇒コメントマークにアンカーを付ける。一応詳細ページのコメント入力へ飛ぶようにした
（参考：https://qiita.com/tatsuya1156/items/595fe0df912c6c89f991）
⇒最後にshowページのform_withのtext_fieldの中にautofocus:  trueにすれば選択状態になる

㉓管理人ブログにドロアー実装（javascript）
⇒javascript超入門読み直し
⇒bracketsがjavascriptに対応しているみたい。ライブプレビューの何も書いてないのに出るfabiconエラーは、下記のコードをheadに入れる
<link rel="icon" href="data:;base64,iVBORwOKGO=" />（https://python5.com/q/nfckbznk）
また、jsの外部ファイルは読み込めないみたい、html本体のファイルに書き込む。

★ドロアーのnavリンクバーの作成
（すでにパーシャルでnavは使われているが、navタグを複数使うときの注意は問題無し）
⇒containerの影響を受けないように、その外の下にコードを書く。
（とりあえず、４つほど適当に<li>タグで作り、パスはroot_pathで一応current_userの引数を付ける）
⇒上のナビバーにドロアー用のアイコンを付ける
（naタグのcurrent_user範囲のendの上にnav-itemもきちんと付けてfontawesomeの大きさを変更してちょうどよい大きさで置く）
⇒post.html.erbのCSS
◍先ず、境界線を貼るためにCSSのセレクタは、必ずpostIndexPageで始めること
◍次にulで付いてしまうmarginとpaddingを０にして、黒点を消す
◍次に、htmlで言う  aリンクの距離と境界線をもう少し整理したいが、ERBのlink_toの場合、class: の所に名前を付ければCSSセレクタとして選択ができる。そして、aリンク要素は、インラインなのでpaddingなどが効かないので、display:  block;でブロックすれば効くようになる。
◍疑似クラスのhoverには、backgroundを付けるとカーソルを合わせた時にその要素全体の色が変わる
◍次に、navタグに対してfixedから始まるテンプレートのCSSを記述
⇒一度ここで確認をする時は、position: fixed;　right: -270px;　top: 0;　を外して見ると下に細長くナビバーが出る。
★ここで確認のためにcssのshowをクラスに付けてみる！postIndexPageと下のnavのクラスにshowを追加（calss="show"）をするが、ナビバーに大きく余白が出来てしまい、ナビバーが付いてこなくなってしまう（これが一番マズイが、取り合えず、navの方だけshowを付けるとナビバーが一緒に動いてくれるので、そこから考える。また、見本では、完全にメインコンテンツのフィールドとは独立しているので、基本は、containerの中ではなく、PageIndexタグの中に置いてみる。）
◍postPageIndexとパーシャルの外にdivタグでwrapperにshow置いてもダメ（ナビバーも動かない）containerにshowはナビバーは動くが、上のナビバーに被ってしまう。そこで、パーシャルファイル自体のnavタグにshowを付けたら成功！ちゃんとナビバーの隣にくっついてレイアウトも崩れない！これで確認は出来たので、showを外して、javascriptでそのshowが二つに付けばいい。
⇒ここで重要なのは、コンテナタグの横の要素にナビバーを付けてしまうと、ドロアーが画面の中に入ってきてしまうが、ちょうど通常ナビバーのように画面一杯までで切れる（width100%）所につけるようにすれば、綺麗に画面の切れ目を境にドロアーが横にくっついている。
また、transform: translate3d(-270px, 0, 0);のshowのｃｓｓを二つに付ける理由は、ドロアーがshowの効果が消えた時に本体の画面も一緒に右にずれないとナビバーに被ってしまう為である。ドロアーが右から出てきたら、本体の画面も右にずれるようにするため、イベントの発火は二つ必要（$('#drawerside, #draweropen').toggleClass('show');）  
⇒ただし、セレクタ選びはきちんと絞らないと他の所にも影響が出てしまうので後で調整する。
◍次に、
1. イベント発火させるマークにクラス名を付けて、このマークにcursolプロパティを
2. showセレクタを適応させるために、通常ナビバーとドロアーナビバーにそれぞれの別のid名を付ける
3. ドロアーを発火させるコードはパーシャルする為に、ドロアーナビバーファイルの下jqueryのコードを書く
4. ドロアーに上にwillnoteの文字をつける
5. 最後に、indexとshowとnewビューのクラス名を同じにしてcssを適用。全てのページにjqueryコードを付ける
◍各link_toのパスの整理はあとで

㉔ noteタスクのsort保存（cookie保存タイプ）
＃javascriptによるsortからの保存の仕方は2種類ある（データベースに保存とcookieに保存する方法）

～計画～
1. cookieに保存するので、cookieを使う方法を考える
2. noteindexページのタスク一覧を動かすためにsortable()メソッドを使いたいので、jqueryのＵＩの取り込みが必要
3. 実際にjqueryとＵＩがビューで効くかどうかの実験を先にする。
4. 今回、railsのidカラムを取得する必要があり、そのやり方を考える
5. scriptの書く場所は、一番下で良い
6. 参考記事：http://www.koikikukan.com/archives/2013/04/16-000300.php
～準備～
⓪jquery-uiの取り込み
⇒まず、railsの最初の環境構築でyarnを使って、jqueryをインストールが終わっているのが条件。次に、UIを取り込むのに必要コードをlayoutビューのhead内に記述（記述する順番注意）
```
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
```
（参考：https://qiita.com/hajimete/items/64a25c08e2f5a3cf929c）

①cookieオブジェクトの取得の仕方（https://www.sejuku.net/blog/54153）
⇒layoutビューに下記のコードをUIコードの下に記述
```
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.js"></script>
```

②jqueryのＵＩ動作確認
⇒下記のコードを実際にビューに書いてみてソートできるか確認
（参考：http://www.koikikukan.com/archives/2013/04/11-005555.php）
⇒また、その中のidの設定を実際のnoteタスクの<tbody>や<tr>タグに入れてみて動かせるか確認
⇒ここまで確認できたら実践開始

～実践～
★jQuery UI の Sortable プラグインにはオプションの他に、イベントが用意されている。その中に、ソートし終わったらイベントが発生するものがあるので、これとcookies保存を使って、ソートしたらcookieに状態が保存されるようにする
★実践のデータがどのような値かは、完成後にconsole.log()で調べられる
ただし！！stopイベントを入れているので、一度動かさないとコンソールは表示されない

メモ：scriptの書く場所について、noteタスクが新規登録されるたびに作られるid付きのデータのそれぞれのidを取得したい時、このそれぞれのデータのidを全て分けて取得するには、そのテーブルデータのタグにid属性を持たせる。そのデータごとのidを取得するには、id名をERBのテンプレートエンジンを使い、note.idで取得する。
trタグにid名をつける。テックピットの
```
 <div id="like-icon-post-<%= post.id.to_s %>">
```
のようにやり、ちゃんと.to_sつける。scriptのコードをテーブルタグの外に書いてしまうと、ビューファイルのテーブルタグで取得しているeachを使った変数を使えないのでidを参照できないので、each文のブロック変数であるnote変数を使えるeach～endの間にscript文を書く。
<table id="<%= note.id %>
$('#<%= note.id %>')で取得できる

①
```
$(function(){ 
  $('tbody').sortable({ 
    stop: function(event, ui) { 
      var id = $(this).parent().attr('id'); 
      var i = 0; 
      var cookie = new Array; 
      $('#' + id + ' tbody tr').each(function() { 
        var number = $(this).attr('id'); 
        cookie[i] = number + ":" + i; 
        i++; 
      }); 
      $.cookie(id, cookie.join(','), { expires: 60 });
     } ＃stopファンクションの中身まで
  }); ＃ここまではsortableの中身まで
```
◍先ずこれは、readyと同じドルファンクションで囲まれている。
◍tbodyをjqueryオブジェクトにすると、tbodyの要素が動かせるようになる。それにstopイベントを付ける。stop: function( event, ui ) {　まではテンプレート。
◍このメソッドでuiにtbodyのデータが入るので、uiをさらにthisで指す。thisはtbody要素のことであり、parent()メソッドだからtbodyの親要素は、tableタグなのでそこの中身も合わせて要素を取得して、その要素のattr()メソッドでidの中身を取得しているので、この場合はsortを取得する。後でsortをcookieのキーにする。
◍ i という変数を用意しておく、cookieという変数に配列を用意
◍<tr>のidを取得する。これは、動かしたいtableタグのtbodyのtr要素をドラッグしてその状態を保存するために取得する。
⇒他のtable要素と混ざらないように、tbodyのtrを指定する必要があり、単純に$('tr')だと、他のtable要素分も含まれてしまう。なのでid名を付けたtableタグの取得して（'#' + id）、そのtableのtbodyのtrと絞っていく
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
★このコードで注意！
$('#' + table_name + ' tbody tr').each(function(){
このコードで必ずtbodyの前をあける事！（スペース）
⇒console.logをこの下のnumberにかけた時にnumberに入ってなかった！（consoleの値が表示自体されなかった）つまり、<tr>のidを取得出来てなかった
（エラーには一切なっていなかった）
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
◍each(function()の形はこのままの通りで、tr要素が入っていく。thisはこの場合、tr要素を指し、そのidをattr()メソッドで取得。cookie変数に入れる。入れ終わったあとのcookieの中身は以下である。
```
Array(3) 
0: "2:0" 　　＃この最初にある０は、取得したデータではなくarray自体のインデックス
1: "3:1" 　　＃つまり、["2:0", "3:1", "1:2"]という中身になっている
2: "1:2" 　　＃これをjoinのコンマで区切ると"2:0,3:1,1:2"
length: 3
```
◍保存したcookie変数をjoinでコンマ区切りにして文字列にして、本物のcookieに保存。つまり$.cookieが本体で、その中のcookieはさっき空配列を保存した変数。
中身は
```
console.log($.cookie())
⇒sort: "3:0,2:1,1:2"

$.cookie('キー', 値);　＃cookieに値を保存したい時
```
◍cookieの削除は、$.removeCookie(値)
★値は$.cookie()の（）に入れたキーを当てはめる。今回ならidだが、このidは変数であり、sortableのstopの中ではないとid変数が参照できないので、sortable内に入れる
★問題は、sortableのコードの中に削除コードがあるので、ソートしてからじゃないとクリックしても効かない

②
```
$('tbody').disableSelection();  #このメソッドはオプションが無いので｛｝が無い
var table_name = 'sort'; 
var index_cookie = $.cookie(table_name); 
if(index_cookie) { 
  var index_hash = new Array(); 
  $('#' + table_name + ' tbody tr').each(function() { 
     var html = $(this).html(); 　＃<tr>要素の<td>要素をhtml()メソッドで取得
     var number = $(this).attr('id'); 
     index_hash[number] = html; 
  });
```
◍続いてcookieを読み出して並び替える処理。これはページ読み込み時に実行される処理である。
つまりここでは、最初に表示されたnoteタスクのtableデータをcookieデータが残っているなら取得している。最初に表示された状態を先ず、index_hashに格納
sort: "3:0,2:1,1:2"　('キー', 値)を取得するためにキーにtableのid名を入れてアクセスする。
◍これで、もしcookieデータが存在するなら（true）、
⇒これもさっきと同じで、<tr>要素を取得して$()メソッドでオブジェクトにする。
⇒html()メソッドは引数が無いなら、オブジェクトの中身を取得
（現在のtr要素の中身（td要素））
⇒下のattr()はさっきと同じで<tr>要素のidを取得
⇒さっき取得した<td>要素を（html変数を）、先ほど作ったindex_hashにインデックス番号とセットで中身を格納していく。

③
```
     var list = index_cookie.split(','); /* , でjoinで繋げた文字列を配列に*/ 
     var i = 0; 
     $('#' + table_name + ' tbody tr').each(function() { 
       var val = (list[i].split(':'))[0]; 
       $(this).html(index_hash[val]); ＃<tr>要素の中の<td>を入れ替える
       $(this).attr('id', val); 
       i++; 
     }); 
   } 
});
```
◍index_cookieの中身は
```
3:0,2:1,1:2
3:0,2:1,1:2
splitで["2:0", "3:1", "1:2"]のような感じに
```
⇒sortはキーなので、あの時点では中身が取れている
◍対象要素.html( 文字列 )　で<tr>要素の子要素が丸々変わる（こっちは、<tr>の中身の方）さらに、<tr>要素自体にもidとvalを入れておく。
（配列listから取得した、並び替えられたtd要素を設定します。また、次の並び替えに対応できるよう、tr要素のid属性値も書き換えておきます）

④cookieの削除
```
$('#cookieRemove').on('click', function() { 
     var test = 'sort' 　　#追加 
     $.removeCookie(test); 
  });
```
🔺ハマり：cookieのデータをリセットするには$.cookie(key); で消すが、keyに当たる部分は上記では、sortableメソッドのstopイベントの中にある「　$.cookie(id, cookie.join(','), { expires: 60 });　」のidであり、このidを消せればcookieは消せる。ただ、このidを参照するには、このsortableのstopイベントの中にコードを書かないといけないので、実際にユーザーがテーブルを動かし終わったら（stop）ではないとcookieを削除できない。stopの外にコードを書いても参照されないので詰まった。

★解決：もう一つの考え方として、keyの中身を取得できれば、それをメソッドに当てれば消せるはず。consoleのlog()メソッドでもidの中身はsortであり、最初のコードの変数にもこの値を入れている。
⇒重要：つまり、ページが更新された次のページではcookieデータが残っているので、並び替えがされたままである。更新されたページのcookieの中身でkeyに当たるものが何か分かれば、idというkeyを参照しなくていいのでsortableメソッド外の箇所にコードを書いても大丈夫である。そして、keyの中身はsortなので、それをそのままダイレクトに変数に入れて（var test = 'sort'）、その変数をkeyに当てれば消える。
（$.cookie(key)でcookieの中身を取得できるが、それはkeyの方ではなく、valueの方）



◍最後にnote用のscssファイルを作り、<tr>要素にcursol: move;を付ける

㉕管理者用のホームページ
1. ルーティングは、オリジナルで作る（get "/admimhome", to:  "posts#home"）
2. コントローラーにhomeアクション追加（中身は要らない）
3. postビューにhome.html.erbファイル追加して、通常バナーとドロアー、cssを適用するためにページのクラス名をpostPageにする
★次に、rails6のwebpackerにおける画像の読み方
https://qiita.com/hida-yoshi/items/55dc48477201dc195bb8
⇒これを参考にjavascriptフォルダーのpacksのapplication.jsのimageのコメントアウトを外す
⇒後は、ビューファイルにテンプレートエンジンでimage_pack_tag～と書いて、javascriptフォルダーに自分で作ったimagesフォルダーの中に画像データを入れて、ビューにパス指定無しでその画像名と拡張子を付ければ出る。画像の大きさなどを変えたい時は、コンマしてclass: を付ければcss指定できる
<%= image_pack_tag "coffee.jpg", class: "test" %>

◍レイアウト
- headerの画像の下にlogo文字を入れるが、relativeだとそのままその空間が次の行に残ってしまうので、absoluteで配置
- CSSの画像の配置は、figureタグで縦に並べて、その親クラス（archivemain）にflexをかけて、justify-contentで等分配置にする。この時、画像自体の幅と高さはきちんと設定すること
- display: flex;の横担当は、justify-content、縦担当はalign-items。
- 出来たら、それぞれのナビバーのリンク先を設定


㉖メールの送受信
（https://www.blograils.com/posts/rails-contactform：これとテックピットを参考に）
★準備
contactsテーブル
Contactモデル
	- name（string null無し）
	- email （string  null無し）
	- content（text  null無し）
	- validates :name  presence: true,  length: {maximum: 30 } 
	- validates :email  presence: true
	- validates :content  presence: true
※今回送るだけなので、外部キーは要らないとした
⇒先ずコントローラー作成、rails g controller contacts new confirm complete
⇒ルーティングのconfirmとcompleteのHTTPメソッドをPOSTにする（これらのページは入力された項目を送信するため）
⇒モデル作成、全てにnullを設定してmigrate、Contactモデルに検証をかける（ここでは正規表現は要らない）
⇒ja.ymlの日本語表記も追加

★コントローラーの設定
＃先にcurrent_userしか表示出来ないようにbefore_acrtionをかける

★newアクション
◍まず、いつもの　@contact = Contact.newだけ書いて、先にビューを完成させてしまう。
★注意！！
⇒ビューのform_withは、model: @contactだけだと、次の行先がデフォルトでindexアクション担当のcontacts_pathになっている。今回、indexアクション、ルーティングを作ってないので、ビューを表示させると
```
undefined method `contacts_path' for #<#<Class:0x00007fffc60a6400>:0x00007fffc60a4498>
Did you mean?  contacts_new_path
```
というエラーが出る。これを解消するには、form_withの次の行先を指定する必要があり、今回の予定はnewページからconfirmページなので、
```
<%= form_with(model: @contact, url: contacts_confirm_path, local: true) do |f| %>
```
このように指定する。（form_with後の（）はwithの後にくっつけること）
⇒次に、ドロアーのお問い合わせリンクを繋げてしまう

★confirmアクション
⇒contactのnewビューから、確認用のconfirmビューに一度飛ばすので、createアクションでは、confirmアクションをrenderする（confirmビューで、入力したデータがそのまま使える）

◍今回はconfirmページに飛ばすので、ストロングパラメーターを追記して、saveコードを書いたらrenderでconfirmを選択
◍newビューファイルにalertが出るように追記
◍confirmビューファイルに関して
- 確認画面なのでフォーム入力は必要ないが、入力したデータを前のページからパラメーターとして持ってきたいので、hidden_fieldでカラム指定をして、コントローラーからの@contact変数をその後に記述する
- cssについて、borderの長さを変えたい時は、要素自体のwidthを％で指定して、margin: 0 auto; で真ん中寄せにする
★入力画面に戻るときに入力したパラメーターを残すためには、、
（参考：https://remonote.jp/rails-confirm-form）
（こちらでも同じようなコードあり：https://www.blograils.com/posts/rails-contactform）
⇒ルーティングを触ったり、バック用のページを作ったりなど色々あるが、先ず、confirmビューのform_withではcompleteへ繋げるという指定をしている。なので、コントローラーのcompleteアクションにもしbackを使ったら、params[:back]でパラメーターを維持してnewページにrenderするという記述をして、form_withの送信ボタンの所に同じく、submitとしてボタンをおいて、name: "back"というコードで戻る。
このname: "back"のnameは属性のnameではなく恐らくメソッド用のname。最後にconpleteアクションのparams後にbinding.pryを置いたら、やはり入力内容が入っていた。確認画面の時にwindowsの戻るとルーティングエラーになるので、必ず戻るボタンで戻るようにコメントを下に書く

★acrtionMailerの設定
◍まず、googleアカウントを取得
＝＝＝＝＝＝＝＝＝＝＝＝
名前：島野礼
アドレス：rails.st.rails@gmail.com
パス：st1234-1234st
＝＝＝＝＝＝＝＝＝＝＝＝
⇒二段階認証無しで安全性の低いアプリ設定をオンにする

◍次にconfigのenvironmentsの開発と本番にメールの設定を入れる。
◍重要：ここで本番にこの機能で出す場合問題があり、
1. 他の人とソースコードを共有した場合に、コードが見えてしまう
2. デバッグ等で機密情報を変える際、ソースコードから設定を探し出す必要がある
⇒これらの問題を解消するために、環境変数を利用し、その設定をする（３－１）
1. dot-envジェムのインストール
2. プロジェクト直下に.envファイルを作り、環境変数の設定
3. その変数を開発と本番のメールアドレスとパスワードに当てはめる（ENV[LOGIN_NAME]）
4. authenticaitonをloginにする
5. .gitignoreの一番下に.envを書く

◍メーラーの作成（ここから注意！ちょっとでもコードの配置やインデントを間違えるとエラーになる）
https://www.blograils.com/posts/rails-contactform（これも参考に）
⇒rails g mailer contact received_email
（rails g mailer メーラー名 メソッド名）
結果：
```
create  app/mailers/contact_mailer.rb #誰に向けてメールを送るか。ここにジェネレートしたメソッドがある
invoke  erb 
create    app/views/contact_mailer 
create    app/views/contact_mailer/received_email.text.erb 　＃メール内容
create    app/views/contact_mailer/received_email.html.erb 　　
invoke  test_unit 
create    test/mailers/contact_mailer_test.rb 
create    test/mailers/previews/contact_mailer_preview.rb
```

★app/mailers/application_mailer.rbの編集（全メーラー共通の設定）
＃ここでは、送信側のメールアドレスを入力
```
class ApplicationMailer < ActionMailer::Base 
  default from: ENV["LOGIN_NAME"] 
  layout 'mailer' 
end
```
◍共通の処理・設定を記述する場合にはdefaultメソッドを使用する。
◍defaultメソッドのプロパティはいくつかあり、その中のfromはメール送信元名になる。
⇒これも漏れないようにENVをかける

★重要：app/mailers/contact_mailer.rbの編集
⇒ここでは、誰に向けてメール送るかという設定になる。ユーザーが入力した内容を送るのだから、from: @user.email（引数のユーザーのemailカラム）、to:  ENV["LOGIN_NAME"]（内容を自身のアドレスに送る）。ここのfrom: とto:の設定を反対にしたりしないこと
⇒つまり、後に作るメール本文の内容は、自身に向けての（管理者への）メールであり、このユーザーからこのようなお問い合わせがあったという文面でつくることになる。
⇒書き方を間違えるとエラーになるので注意！
```
class ContactMailer < ApplicationMailer 
  def received_email(user) 
    @user = user 
    mail from: @user.email, 
         to: ENV["LOGIN_NAME"], 
         subject: "【willnote】webサイトよりお問い合わせがありました" 
  end 
end
```

★received_email.text.erbとreceived_email.html.erbの編集（メール本文）
◍railsでは、htmlのメールが送れない時は、textメールが送られるようになっている。
★completeページの編集

㉗整理整頓
★ユーザーの新規登録のエラーメッセージ
```
<%= form_with model: @user, local: true do |f| %> 
    <% if @user.errors.any? %> 
      <div class="alert alert-danger" role="alert"> 
        <strong>入力内容にエラーがあります</strong> 
        <ul> 
          <% @user.errors.full_messages.each do |msg| %> 
           <li><%= msg %></li> 
          <% end %>  
        </ul> 
      </div> 
    <% end %>
```
◍テンプレートで覚える。container下のform_with下に置いて、そのモデルで扱うカラム（属性）を変数で受け取る。（この場合は、@user）
◍ちゃんとエラーメッセージが日本語になっているのは、最初のja.ymlの設定もあるから
★configのja.ymlにはerrorsメソッドがあり、モデルを作らないsessionなどは、ymlに記載がないのでerrorsメソッドが使えない。コントローラーでalertを設定して、bootstrapのalertをviewに使う！

★ログインメッセージのフェードアウト
```
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
◍jqueryを使う。メッセージ出力コードの本体にidを設定して、そのfadeout()メソッドを使う



★Userモデルのemailの正規表現とpasswordの制限（！注意あり）
https://note.com/simesime/n/n7b9dbf3a80d6（参考）
https://pikawaka.com/rails/validation（pikawaka）
```
validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i } 
validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "：@を入れてください"} 
validates :password, length: {minimum: 6, maximum: 20}
validates :password, format: { with: /\A(?=.*?[a-z])[a-z\d]{6,20}+\z/ }
```
◍formatとwithで正規表現を行う
◍ビューにエラーコードを入れていたら、上のようにmessageを使って、エラーメッセージを変えることもできるが、少し工夫が必要
◍パスワードは２１文字で入れるときちんとメッセージに２０字以内でと出る
★ここで注意なのが、これ新規登録された時は、この検証で良いが、登録後のプロフィール変更ができない。プロフィールには、パスワード欄が無いが、検証をかけてない時は、そのままの変更が出来たが、検証をかけると入力が必要になる（confirmationの所）
⇒Userモデルでpasswordの検証の後に、on:  :createを付けることによってupdateの時は必要ないように出来る


★cssの整理と手段
（cssを適用する時は、出来るだけページ専用クラス指定にすること）

◍form_withの入力欄を狭めたい時は、、その中のform-groupにクラスを設定してcssをかける
```
.loginPage .test { 
    width: 80%; 
    margin: 0 auto; 　　＃両側からの真ん中寄せ
}
```

◍fontawesomeの位置調整
```
<i class="fas fa-cheese fa-4x cheese" data-fa-transform="down-3"></i>
```
⇒data-fa-transformで位置調整を指定できる

★SEO対策（検索エンジンの最適化）
http://vdeep.net/rubyonrails-meta-tags-seo（項目のそれぞれの説明）
https://creat4869.hatenablog.com/entry/2019/08/15/170109（概要）
https://yoshikimi.com/programming/rails/4（rails 6のファビコン）
⇒先ず上記の概要を順番にやる。helperのコードもコピー
⇒ここでは、ツイッターを抜いて、3つの画像を作成する
★ファビコン用とapple用は、rails6のファビコンのリンクのジェネレーターで作れる
★ogp画像は、https://pablo.buffer.com/　で作れる
注意！:今回のseo用のファイルを使った時の、ファイル名は、適当ではなく、favicon icon  ogpという名前のファイルにすること








㉘管理者プロフィールの作成（グリッドシステム、javascript（切り替え画像）、段取りの振り返り）
★切り替え画像の高さにより、グリッドの高さが変わってくるので注意！
①ルーティング、コントローラーアクション、viewファイルの設定
②通常ナビバーとcss用のpostPageクラス、ドロアー＋scriptコードとページ専用クラス、containerの設定
③containerの中にrowクラスを入れて、col-mdの振り分け
④先ず、切り替え画像から
◍グリッドシステム：rowクラスは、振り分け用。これを設定すると１２の中なら横並びになる。rowクラスの中にまたrowクラスを入れることも可能。
◍colの中の要素はデフォルトでpadding:15があるので、そのcol自体をcssで指定してpadding:0にすれば隙間はなくなる。bootsrtapで
px-0にすればできる
1. 先ず、大枠のrowクラスにwidthの幅を決めてしまい、margin:0 autoで真ん中寄せ。marginの上下を余白を作り離す
2. それからrowの中をcolで割り振る
3. 左部分は、先ずメインとなる画像コードを記述し、その下にさらにrowクラスを付けて（これが無いと横並びにならない）、col-mdで分割する（col-md-7配下を１２分をさらに4等分する）。分割したcolの中に画像コードを書いて、それぞれにクラス名を付ける（select1, select2...）
4. それぞれの画像をcssで幅と高さを変えて小さく収まるようにする。
5. 次にjqueryコードを書く
～ポイント～
◍下にある小さい各画像をクリックすると、メインの画像が変わるようにする
◍erbのimage_pack_tagの指定はできない？javascriptのままではなく、jqueryの方が指定しやすいかも
◍！！重要！！：ＥＲＢが表示された時のhtmlコードは画面の検証で見ることが出来る。そして、image_pack_tagはhtmlだと、ちゃんと<img～とsrc=""で出力されているので、コードで書いてなくてもimgタグやsrc属性をメソッドの属性値としてセットすることができる！
⇒jqrueryメソッドのattr()メソッドでは、（　）内で、最初にclassやid、srcなどをセットして、次に属性値やパスを書く。'src'とセットして、次にどこかのネットのhttpsから始まるパスを打てば、src属性をそのパスに変えることができ、画像を出力できる。
⇒ここで自分がimage_pack_tagのコードをインターネットの検証で見ると、srcの表示もあるので、そのパスをコピーしてattr()メソッドのパスに入れてあげれば、その画像を参照できる。
（ヒント：https://qiita.com/ore_public/items/52b2ce119cb26399d876）
（ヒント：https://www.buildinsider.net/web/jqueryref/007）


㉙readme
⇒https://cpp-learning.com/readme/(参考)
⇒実際のgithubを参考にするのもいいかも（bootsrapなど）

```
* Name <!-- プロジェクト名 -->
  =>  willnote
* Demo <!-- 動作例や画像の貼り付け -->
* Usage <!-- willnoteの基本的な使い方など -->
* Features <!-- 特徴やセールスポイント -->
  =>
* Ruby and Rails version <!-- バージョン -->
  => ruby 2.7.1p83
  => Rails 6.0.3.4
* Requirement <!-- willnoteを動かすためのライブラリなど -->
  => rbenv 2.7.0
  => yarn 1.22.5
  => Bundler version 2.1.4
  => node v10.19.0
　=> yarn 1.22.5
* Licence <!-- ライセンス -->
　=> MIT
* Author <!-- 作成情報 -->
  => name: toshi
```
①Nameはプロジェクト名
②Demo（gifを作成するのがいいかも）
⇒screenToGifを使って録画する。このgifの画像のパスを貼り付け、軽く説明。
⇒read meはマークダウン形式で記述できるので、同じディレクトリの中にgifファイルを入れて、下記の形式で書くとリンクになる
```
![](willnoteDemo.gif)
同じ配下のあればパスもいらず、ファイル名でいける
```
③ライセンス（https://www.catch.jp/oss-license/2013/09/27/mit_license/）
⇒ここを参考にファイルを作っていく

㉚Git
①Githubの登録、git入門教室を読み概要を掴む
②下記を参考にgitbashをインストール
⇒https://blog.totsugeki.com/post-279/（これを参考にgitbashインストール）
⇒https://hacknote.jp/archives/11885/（gitbashのconfigの消し方）
⇒インストールできたら、、https://www.sejuku.net/blog/72673を参考に開いてみる

③次に秘密鍵と公開鍵を作成する
https://qiita.com/reflet/items/5c6ba6e29fe8436c3185（フォルダを作る所からある）
https://yu-report.com/entry/githubSSH（鍵をつくった直後のconfigの作成）
◍echo ~　コマンドで現在のホームディレクトリを指す
◍フォルダを作ってからではないとエラーが起きる。パスフレーズは設定しないで空打ちする
◍無事できればtoshiki配下に.sshディレクトリ内にファイルが作成される
```
Your identification has been saved in /c/Users/toshiki/.ssh/id_rsa 
Your public key has been saved in /c/Users/toshiki/.ssh/id_rsa.pub

id_rsaが秘密鍵、
id_rsa.pubが公開鍵:この内容をgithubに登録すると登録したgithub所持者のgithubにキーを使って接続できる
```
◍次にconfigファイルをsshディレクトリ内に作る
◍githubに公開鍵を設定
◍ssh -T git@github.com　コマンドでカギの接続が出来るか確認（最初は、接続して大丈夫かという質問がくるのでyesを押す）


④techpitのgit入門へ＋サルさんのGit入門（rebaseとtag見る）
◍２－５のtreeコマンド：gitbashでecho ~でホームディレクトリはUser/toshikiだとわかるので、cdでそこまでいき、touchで.bashrcを作成。そこにコードを書いて、gitbashを再起動すると使える
◍https://qiita.com/rorensu2236/items/df7d4c2cf621eeddd468
⇒最初からsshでremoteの登録をすればいちいちパスワードを聞かれない

★ある時点でのブランチ（master）から分岐して新しいブランチ（feature）を作成したとき、そのブランチで新規ファイル作成、コミットまでやったら、それを今のリモートにpushする時、、、git push originだと、上流がないと言われる。
⇒基本は、git push origin ブランチ名！で送信する
⇒最初の設定で、git push -u origin ブランチ名でやると次は、-uのおかげでgit push originで済む

★ブランチを変えて、そこでファイルを作成したときに、そのファイルを閉じないで別のブランチにチェックアウトした場合、その画面に残っているファイルは当然未保存状態になる。（そのブランチでの作業が終わったら、そのファイルを閉じることをやる）

★githubで直接ブランチを削除した場合、次にローカルのブランチをデリートするが、branch -aをやるとremotes/の形でリモートブランチが残ってしまう。その時は、git fetch -pで一掃できる！
https://noumenon-th.net/programming/2019/12/29/git-branch-d/（ここを参考に！）

★テックピットのrebaseについては、サル入門Gitの方が正しい！
（rebaseを使った、pushをしていないファイルの二つ以上前のコミットの修正の仕方。git commit --amendは直前のみ）


★Gitのルール
◍commit　push　rm　-dは絶対に確認を取ること！
◍そのブランチの変更するときに、作業したファイルを閉じること！
◍ローカル内でマージをした時、リモートには反映されてないのでpushが必要だが、、pushは要注意！
◍基本rebaseは要らないが、、pullのrebaseは使えそう？他にも、コミット複数やり直しのrebase -i HEAD~3
◍git push -fは絶対に使わない！（強制プッシュ）

～ポートフォリオの上げ方～
◍gitignoreに.envファイル（メーラー機能を使っているなら）とconfigのmaster.keyファイル（デフォルトでgitignoreにあり）
◍pushする場合、リモートはpublicにすること（プライベートだと相手が見えない）

①taskleaf というプロジェクトがあるなら、taskleafがカレントディレクトリの状態で始める。（railsで作ったプロジェクトは最初からinit(初期化済み)されている）
②git add.
③git commit -m 'テスト'
④githubでリポジトリをつくる。（見せるならpublicで、nameはプロジェクト名で）
⇒sshURLを確認
⑤git remote add origin sshのURL
（ローカルのリモートにsshのリモートをoriginという名前で登録する）
⑥git push origin master
（リモート名とブランチ名はセット！）
～実際の操作～
★プロジェクトのファイルを一部変更。そのファイルをステージングする時には、git add　パス名 になるが、このパスを間違えるとうまくいかないので、正式を見るにはgit statusで見るとパスが分かる。
⇒ファイルを変更した後に、もし完全にスペースなども考えファイルのコードを戻せるなら手動で戻すか、Ctrlとｚで最後まで戻せるなら、それを再保存すれば変更状態は解除される。
⇒ステージングしたファイルの内、特定のファイルをコミットしたい場合は
```
git commit -m 'test' --controllers.rb
git commit -m 'test' --controllers.rb test.rb ＃複数の場合
```
⇒だたこれは、ステージングさえしなければ良い。コミットするものだけをステージングするようにしていく。


㉛rspec（rails6のエラーあり。最初のrspecのgemインストール注意！テックピットは1章2章要らない）
★system specという機能を理解する（速習Ｐ１８４～Ｐ１９４）
★https://qiita.com/amatsukix/items/578f85cf4565ca2a797c（rails6のrspecエラー）
⇒　gem 'rspec-rails', '4.0.0.beta3'　をインストール
◍http://vdeep.net/rubyonrails-rspec-factorybot-capybara（古いが構築の参考に）
◍https://blog.jnito.com/entry/2019/10/25/053521（伊藤さんからのrails6のrspecの変更点）
◍https://qiita.com/ham0215/items/7516117df87d2631e31d（databasecleanerは入れない方がいいらしい、速習でも不要とあり）

⓪上記を確認後、下記の順で構築する。rspecのバージョンはgem 'rspec-rails', '4.0.0.beta3'。（速習でも同じ手順）
https://takumalog.com/2020/05/08/post-104/
◍rm -r ./testコマンドで消えるのは、プロジェクト配下のtestというディレクトリが消える。
◍FactoryBotの省略については、、確かにあった方が何をしているか分かりやすいが、、build、create、newだけで付いていると考え慣れた方が速いかも
◍テックピットより
```
bin/rails db:migrate:reset RAILS_ENV=test
テスト用のDBを最新の構成にする
```
テスト用のDBとは自動テストを実行するときに利用する専用のDBの事。例えば自動テストで「全データが消えること」を確認するとき、開発中に利用しているデータが消えてしまっては困るので、開発中のデータと自動テスト用のデータの双方が干渉しないようする。

▲ここで注意！：実はまだ、capybaraという機能に設定を出来ていない。
⇒railsにはプロジェクトを作った時にすでにインストールされているが、spec_helper.rbにcapybaraをrequireしただけではまだ足りない。
◍エラーの状況としては、テストをすると、カピバラが読み込まれていない。特に、visit login_pathのlogin_pathがnameエラーになるので、原因としてわかりにくいが、visit(URL)のやり方だと、エラーでvisitがnometodになっており、カピバラが読み込まれていないことが分かる。その解決策が以下である。
◍https://qiita.com/terufumi1122/items/aefd6c965e9e946efc3b
🔺：capybara~DSLをやるとテスト結果にcapybara~とは出ないがテストは通る
🔺：まず、typeをsystemにすると、ちゃんとpuma capybara~と出てエラーが出る。ディレクトリだけをsystemという名前にしてもvisitがno methodというエラーになるので、rspecファイルのtypeが大事か
🔺：ディレクトリをsystemにすると、その中のファイルがちゃんと色付けされる
～解決～
最終的には、、
1. rspec以下のディレクトリをsystemにする
2. テストファイルの最初の記載のtypeをsystemにする。
3. bundle update rspec-rails capybara selenium-webdriver　を打って、各機能を最新にする（直接的な策ではないかも）
4. これが決め手：
⇒webdriverのエラーの上に、Failure/Error: visit("http://localhost:3000/login")　と出ていたので、普通のvisit login_pathにしたら、capybara pumaが出た状態でテストが通った！
⇒これを考えるとvisit(URL)という手法が今のバージョンだと使えないのか。
⇒因みに、rspec下のディレクトリをmodelsでrspecファイルのtypeもmodelだと、上記のcapybara~DSLをやるとテストは通るが、system specではないっぽいので、やはり、systemと記載した状態でテストが稼働するか確認する。

⓪スクリーンショットについて、、
◍system specとcapybaraでテスト失敗時にスクリーンショットが記録されるが、それは、プロジェクト下のtmpファイルにある。エディタによって、表示される、されないがあるので、エクスプローラーから見るのが良い。

①注意！：specというディレクトリができたら、factorieseというディレクトリを自分で作って、その中にモデルと同じファイルを作る（users.rb）のだが、、
⇒例えば、Userモデルの登録のテストをするなら、rails g rspec:model User　というコマンドできちんとしたファイル名で各ファイルの最初の走り書きも付けてくれる。
（作成されるファイルとディレクトリは、この場合specディレクトリの中にfactorybotとmodelというディレクトリが作られる）
⇒作成したspecファイルの　pending "add some examples to (or delete) #{__FILE__}"　は要らない
⇒したがって環境構築を終えたら、どのモデルのデータをテストするかを考える。（User、Note、Postなど）
⇒そうなると、ER図があるとテーブルを見られて便利かも
②UserモデルとNoteモデル
```
⇒ rails g rspec:model User
⇒ rails g rspec:model Note
```

notesテーブル（Noteモデル）
usersテーブル（Userモデル）
	- name(string　null無し デフォ無し)
	- memo1(text)
	- memo2(text)

＝＝最初から作るなら＝＝
	- user(references型  null無し)
　　⇒user_idとインデックスの自動追加
	- name(string　null無し デフォ無し)
	- email(string　ユニークtrue、null無し デフォ無し)
	- password_digest(string 
　　⇒passwordとpassword_confirmation　
	- 後でadmin追加（boolean  null無し）
1. willnoteへのログインの動作確認（userデータが登録されている必要あり）
2. noteデータがちゃんと登録されるか
3. ここでは、UserモデルとNoteモデルが紐づいていることも考慮に入れる

⇒以上を踏まえて、テックピットではログイン機能ではないから、最初のコードは通らない。したがって、速習の順番で進めていく

①factorybotの編集
◍ファクトリー名（:user）をモデルと違う名前で付けるときは、クラスを指定して名前を付ける
（factory :user do     を　factory :admin_user,  class: User  do）
◍noteのファクトリーには、下にuser（factory名）を付ける。アソシエーションしているから
◍create(:note, name: "最初のタスク", user: user_a)のuser: はnoteファクトリーファイルの下につけたuser
◍capubaraのfill_inの後に書く、”ログインする”などは、実際に画面上にその名前の欄があり、コードのラベル名にも書かれていないと効かない
◍ユーザーを作成する時にadminをtrueにするか確認する
②速習を参考にrspecファイルの記述（最初のtypeは必ずsystem）


🔶rspec上達！
- .newで（）内にデータを書くときには、コンマが必要
- ログインが必要なシステムはまずそこから書かないといけない
- createやnewを変数に代入する場合、それを後で使うなら「＠」を付けると使いまわせる。付けないと他の場所で使えない。後は、＠を使わない変数を使う場合、スコープを考えてit文を作るなら、同じ変数データを使うにしても、もう一度.newなど記述をしないといけない
- テストを実行するときに、そのファイルにcapybaraのメソッドが使われてない時は、ターミナルにcapybara pumaと出ない
- factorybotと自分で.newを使うとき。同じメールアドレスの登録が出来ないことを検証するとき、factorybotで先に用意してしまうと、そもそも最初から同じデータが作られてしまうので、コード自体通らない。流れの中でデータを作りたいなら、factorybotを使わないで自身で順番に上から.newでインスタンスを作っていくと、その流れに沿って検証を行える。
- letは、decribeかcontextの配下ではないと効かない！it配下では使えない
- before doにログインの流れを入れている場合、ログインを必要としないテストーケースがある時は（単純な.newなど）、そのケースをbefore doの及ばない箇所に記述すること（ログインのbeforeとそれを必要とするケースをcontextで囲み、その外に新しく記述すれば、ログインの影響を受けない）
- 原則として「1つの example につき1つのエクスペクテーション」で書いた方がテストの保守性が良くなります。
- letは遅延評価である。letで定義されたメソッドが、結果までに呼び出されないとエラーになる

★rspecを使って考えるテスト
①検証通りにユーザーやタスクの登録ができるか
②アソシエを結んでいるユーザーとタスクの関係で（has_many :notes, dependent: :destroy）、ユーザーが削除されると、タスクも消えるか
⇒下記を参考に、、
(https://qiita.com/paranishian/items/51d3742b7095aa7744ca#%E5%8F%82%E8%80%83)
⇒今回user_cがdestroyされたら、changeというマッチャを使って、Noteモデルのデータが減るというケースを考える。
⇒まず、アソシエとログインしないとアプリを使えないので、factorybotを使ってアソシエしたタスクを作って、capybaraを使ってログインをする。
⇒ここで、it構文の中身をchangeメソッドの書き方でこのように書きたくなるが
```
expect(user_b.destroy).to change{ Note.count}.by(-1)
```
⇒ここでテスト実行すると、but was not given a blockというエラーが出る。そこで何でもいいのでブロックの形で渡せばという考えで、user_cをProc.newでプロックオブジェクトにしてやるとうまくいく。（changeはexpectの内容をブロックにして渡さないといけない）
```
expect( Proc.new {user_b.destroy}).to change{ Note.count }.by(-1)
expect( Proc.new {user_b.destroy}).to change{ user_c.notes.count }.by(-1)
#どちらでも通る
```

③コントローラーテスト
⇒コントローラーをテストするには、spec下にrequestsディレクトリを作って、rspecファイルのtypeをrequestにする。一番簡単なテストがこちら
```
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
◍２００は、リクエスト成功のステータスコードで、 、ページがちゃんと表示されていれば通る 、３０２はリダイレクト。
★https://qiita.com/tanutanu/items/14b0a1729069b53aa5b8（リクエストでログインをする方法）
★https://qiita.com/necojackarc/items/17bbeae646e331eb5649（rspec下にsupporディレクトリを作って、オリジナルメソッドを使えるようにする）
⇒これに追加で、rails_helperファイルのRSpec.configure do |config|下にconfig include モジュール名を記述
★postで登録する場合のparamsの渡し方
```
post users_path, params: { user: { name: "tarou", email: "abc@au.com", admin: false, password: "password", password_confirmation: "password" }}
```

④画像の登録のテスト
◍https://nanayaku.com/rails-rspec-carrierwave/（基本があり）
⇒UserモデルとPostモデルとPhotoモデルのアソシエ（id）を考える
⇒imageのパスは画像があればどこのディレクトリでも大丈夫なので、テスト用にrspec下に置いてもいいし、直接画像があるjavascript下から追っても良い
⑤テストデータの自動削除？
◍画像登録のテストなどをしていくとデーターが溜まっていく？らしいので、upload設定ファイルの画像が登録される場所を変えるなどの操作があるらしいが、、https://qiita.com/tmyn470/items/6355c252022e80d682d8（画像データの自動削除）
必要ないか？https://qiita.com/a_ishidaaa/items/b17ca8fa1a50ed5c3802（テストデータはどこへ消えた？）
⑥rspecとcapybaraとjavascript
⇒https://qiita.com/koki_73/items/ffc115ed542203161cef（javascriptの設定とやり方）
◍本記事では、featuteテストで行っているがsystemテストでも同じようにできる
◍次に、describe、context、itのdoの直前にjs: true を入れるとcapybaraで触れるようになる（jsを使いたい所に記述する）

★投稿画像一覧に飛べないエラーについて：下記は通らないコード
```
RSpec.describe Photo, type: :system, js: true do  
    before  do 
        @user = create(:user, admin: true) 
        @post = Post.create( 
            caption: "test", 
            user_id: @user.id 
        ) 
        @photo = Photo.new( 
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
◍問題について：find~clickでドロアーをクリックは出来たけど、次のclick_linkで投稿一覧にいけない
🔺エラー：
①user_idの１が見つからない
②それを解消しても、imageにデータが登録されてない

～①のエラーについて～
⇒このエラーは、ブログの画像表示を管理者のものだけにするため、postコントローラーでUser.find(1).posts~でデータを表示させるようにしていたので、実際には投稿一覧にはユーザーid(1)が表示されないといけないという自身の作った環境が原因。そもそもテストデータが作られている時にユーザーidが１で作られているかわからないということもあったので、先ず、userをcreateしているrspecファイル中にbinding.pryを置いてみる。そうするとidが１ではないユーザーが作成されていたので、userをfactorybotでcreateする時に、user_id: 1　に設定したら、そのユーザーが作成された。

～②のエラーについて～
⇒user_id: 1 が作られると今度は、imageがnilというエラーが出る。これも事態が掴めなかった為に、binding.pryで@photoを調べてみたら、確かにデータが入ってなかった。その時に、Photoデータの作られ方に目がいった為に気付けたが、どうやらモデルからデータを作成する時に、.newで作成していたのが原因だった。引数は持っていたのにデータは入ってなかった。これを.createにすることによってimageデータがちゃんと入っていた。

～総括～
⇒以上の事から、ドロアークリック後にclick_linkでそのリンクに飛べること確認ができ、テストも通った。自身で画像一覧ページは、find(1)で設定しているのでテストユーザーの作成にもidを１にすることを忘れないようにする。

⑦お問い合わせテスト
★前提
⓪今回は、mailer specになるので、ディレクトリ名をmailers、spec内のtypeをmailerにする
①config/environments/test.rbの中で、
```
config.action_mailer.delivery_method = :test
```
とあるが、これのおかげでspec内で　ActionMailer::Base.deliveries.lastというコードでActionMailerインスタンスを取得できる。
ActionMailer::Base.deliveries.lastの戻り値を変数か（@mailなど）subject入れて使う。
⇒このメソッドは、必ず、deliveriesのあとに何かしたら付けないとエラーになる。これでメール情報を取得できるので、マッチャと組み合わせてテストする。
ActionMailer::Base.deliveries.last
最後に送信されたメールを取得
ActionMailer::Base.deliveries.last.body
最後に送信されたメールの本文を取得
ActionMailer::Base.deliveries.first
最初に送信されたメールを取得
②メールの本文（body）は本文以外の情報(encodingなど)も含まれるため、eq matcherではなくmatch matcherを使用する。そのためにメール本文をencodeしないと日本語のテストができない。
```
# let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }
```
⇒上記のようなことで文をencodeもできるが、上記のコードは日本語（UTF-8）対応していない。

③gem email_specのインストール
⇒http://totutotu.hatenablog.com/entry/2015/09/23/%E3%80%90%E3%83%86%E3%82%B9%E3%83%88%E7%B7%A8%E3%80%91ActionMailer%E3%81%A7%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%92%E9%80%81%E4%BF%A1%E3%81%99%E3%82%8B（参考）
⇒https://github.com/email-spec/email-spec#rspec-matchers
（公式：見るのはメソッドだけでよい。途中にある、rails generate email_spec:stepsコマンドをやると、expect内で使えるオプションの内容が使える）
◍注意：githubの公式に色々あるが、、基本的には、gemをインストールして、rails_helperに「require"email_spec"」を記述（つけなくてもなぜか動く）
⇒必ず、rails_helperに
```
RSpec.configure do |config|　配下に

config.include(EmailSpec::Helpers) 
config.include(EmailSpec::Matchers)
```
を入れるか、specファイル内でincludeする。（これは記述しないとエラーになる）
```
describe "Signup Email" do 
  include EmailSpec::Helpers 
  include EmailSpec::Matchers  
end
```
◍注意：ここでマッチャの方に目が行きがちだが、、expectの（）内も対応したメソッドを使わないとマッチャも使えないようになっている
```
mail.deliver_now
expect(open_last_email).to deliver_to(ENV["LOGIN_NAME"])　＃open_last_emailと使わないとdeliver_toが使えない
```
⇒注意：かなりこれが無いと、という依存関係が強い。上記のmailはletの変数だが、この設定にもきちんとContactモデルからcreateして、そのデータをmailerをジェネレートした時に作ったreceived_emailメソッドに入れてメールを生成すること
⇒さらに、メールを送るメソッドのdeliver_nowメソッドは、received_emailメソッドの後ろに付けて使えるはずなのだが、これをletなどにまとめてしまうとそのletの中で送信が完結してしまうらしく、リアルタイムに反映させるためにはit文の中でdeliver_nowメソッドを使う必要がある。

㉜論理削除
⇒論理削除を実装するのに便利なgemが二つあるが、paranoiaは非推奨（ActiveRecordをオーバーライドしてしまいコンフリクトする可能性がある）なのでdiscardを使う

★discardについて
https://qiita.com/piggydev/items/05e7276ed0cada69da76（参考：基礎）

①gem 'discard'をインストール
②discard機能を使う予定のmodelへの追加マイグレーションファイルを作成（今回ならUserモデルへ：usersテーブルに追加）
```
rails g migration add_discarded_at_to_users discarded_at:datetime:index
```
⇒変更せずマイグレイトする
⇒因みに今まで作成されていたユーザーにも自動的にこの属性が付与されるので消さなくても大丈夫
③Userモデルでdiscardを機能させることを宣言
```
include Discard::Model
```
④新たにユーザーを作って、discard_atカラムが付くのを確認。実際にコンソールでユーザーを論理削除すると、データベースからの検索はできる。
◍ビューコードのlink_toのコードは変更しなくて大丈夫（method: :deleteはあくまでルーティングからコントローラーのdestroyアクションに飛ばすための記述）
◍destroyアクションのdestroyをdiscardに変えると論理削除できる。何も工夫をしないで実際の画面から削除すると、画面にデータが残ったままになってしまうので⑤へ

⑤画面に論理削除されてないユーザーのみ表示する
⇒Userモデルに下記のコードを記述すると、usersコントローラーindexアクションのUserの後ろに付けるもので表示が変化する
```
default_scope -> { kept }

indexアクションに、、
@users = User.all　＃disされてないユーザーが残る
@users = User.with_discard　＃全てのユーザーが残る
@users = User.with_discard.discard　＃disされたユーザーだけ残る
```
🔺注意：画面から消えたdisされたユーザーはコンソールで検索できなくなってしまう。代わりに、disされたユーザーだけが残るコードにすれば画面上は確認できる。
⇒User.allとUser.with_discard.discardの変数を分ければ別々に表示はできるが、、表示するときは直接<%= disusers.name %>とダイレクトに打ってもエラーになるので、each文で変数を一度ブロックに渡す必要がある。（<% @users.each do |user| %>）
★解決：モデルにkeptと打ってしまうとコンソールでも表示されない為、コントローラーにUser.keptと記述すると画面には表示されず、コンソールには出てくるようになる。
⑥削除を退会にする
◍ビューの削除ボタン退会に変更
◍indexアクションに＠@disusers = User.with_discarded.discardedを記述
⇒ユーザー一覧のビューに<%= @disusers.count %>を入れて退会者数が分かるようにする


～ファイナルパート～
🔶前提：Apiとは
◍APIとはソフトウェアやアプリケーションなどの一部を外部に向けて公開することにより、第三者が開発したソフトウェアと機能を共有できるようにしてくれるもの。
◍https://data.wingarc.com/what-is-api-16084（APIとは）
◍『web技術の基本』を読む
◍rails6ではcoffeescriptは使わない（ー>などの関数は使わない）ので、railsチュートリアルではなく、まとめられたものを読む。
◍https://pikawaka.com/javascript/json（⓪から始めるjson入門）

🔶Ajaxと非同期通信とは
◍https://pikawaka.com/word/ajax（Ajaxとは）
◍https://pikawaka.com/rails/ajax-jquery（railsをつかってAjaxチュートリアル）
◍非同期通信は、サーバーへのリクエスト中に別のリクエストを送れる事。そして、受信と送信もずらすことができる。（同期通信は、リクエストとレスポンスが終わらないと次のリクエストは出来ない）。Ajaxは、読み込みなしで一部の部分を変更できる機能であり、アプローチ方法。
⇒非同期通信とは、あくまで次のリクエストをサーバーのレスポンスを待たないで送れることであり、受信もできる仕組みであり、それを実際に実装する方法としてAjaxがある。
https://applingo.tokyo/article/654（非同期通信をAjaxを使って説明してみた）

🔶Apiを叩くとは
◍railsにはApiモードというのがある
◍https://nyakanishi.work/implement-simple-api-in-local-environment/（超簡易的API）
◍【Ruby on Rails】rails で api を叩いてみよう（初心者から中級者向け）（youtube）

🔶Rest-apiとは


🔶ページネーション

◍https://github.com/kaminari/kaminari（公式）


★ページネーションをajaxを使って非同期通信を実装する
⓪kaminari（https://pikawaka.com/rails/kaminari（ピカワカ基礎）を見ながら）
★注意：このgemに限らずだが、このgemではnavタグが重要であり、postページのドロアーのコードの中に<%= paginate @notes %>を入れるとnavクラスのページネーションまで外に行ってしまうため、postpage  navのｃｓｓに入らないようにこのコードを入れること。
★ページネーションを作成すれば、背景画像の無駄な拡大を防ぐこともできる。
◍pageメソッド：page(params[:page])を渡すとビューで<%= paginate @notes %>のように使えるようになる？
◍perメソッド：per（）の引数に１と入れると1データで1ページになる
```
@notes = current_user.notes.order(created_at: :desc).page(params[:page]).per(1)
```

◍ビューに下記のコードを入れるとper()ごとのデータのページネーションが表示される
```
<%= paginate @notes %>
<%= page_entries_info(@notes) %> ページの件数を表示
```

◍上記だけだと見た目を変えられないので、下記のコードでkaminari用のviewファイルを作る
```
rails g kaminari:views bootstrap4
```
⇒viewの後に、自身の使っているcssフレームワークを必ず付けること。これを作成してからビューのページネーションを見ると、ただの数字だった表示に枠がついて、bootstrapが適応されたデザインになった。
◍config/locales/にkaminari_ja.ymlファイルを作り、テンプレート（ピカワカ）を貼る。（この記事はここまで見ればよい）
◍page_entries_infoもymlファイルで表示を変えられる

◍以下のコマンドでkaminariのコンフィグを作成できる
```
rails g kaminari:config
```
①ページネーションのcss編集
⇒先ほど、kaminari用のviewファイルを作成したが、これらのファイルにはいくつかクラスで名前がつけてあり、例えば、_pagentor.html.erbのファイルにはpaginaetionというクラスの名前がulタグについており、下記のようにcssを変えると中央寄せができる。
```
.pagination { 
  justify-content: center; 
}
```
⇒つまり、kaminariの各ファイルのクラスを把握すれば自由にデザインできる

◍件数表示は検証を見てみるとクラスが指定されてないので、text-centerを指定すれば真ん中に移動する
```
<div class="text-center"><%= page_entries_info(@notes) %></div>
```

★ページネーションｃｓｓの各クラス
.pagination
◍ウィンドウ全体部分
◍中央寄せするなら
.page-item
◍表示されている枠部分の範囲
.page-link
◍数字とその背景
.active
◍このクラスが付いているだけでcurrentページが青くなる
◍　'views.pagination.truncate'などviews.～というコードはymlのメソッドを呼んでいる。（表示の出方）

🔶進め方について：
⇒Restfulなアプリを実装していく場合、Vue.jsを使ったり、grapeなどのgemを使う、フロント側のアプリとバック側のアプリに分けて作成など色々あるが、、
前提知識としていきなりVue.jsを勉強するとかではなく、「railsだけでAJAXを使う」という所から始めるのが良い。その発展としてそこにVue.jsを組み込んでいくという段取りの方が良し。
よって、最後にrailsだけを使って、、kaminariのgem無しで！ajaxを混ぜたページネーションを実装する。


1. 
🔶メモ：

◍https://lab.syncer.jp/Tool/JSON-Viewer/（json構文チェック）



★Ajax
https://www.sejuku.net/blog/28967（簡単なajax実装）
https://pikawaka.com/rails/ajax-jquery
j は、escape_javascript のエイリアスで、改行と括弧をエスケープしてくれるメソッドです。
```
$('#apple-form').html("<%= j (render 'form') %>");
```
⇒恐らくjqueryのメソッド内でerbを使う、renderを使う場合にエスケープする

🔶インクリメンタルサーチ（ユーザー管理一覧）
https://qiita.com/yuki-n/items/fdc5f7d5ac2f128221d1（インクリメンタルサーチ）
⓪最初に流れを簡単に表すと、、
1. クラス名ID名が付いた検索窓を作成（formタグ）
2. 検索窓から入力されたデータを取得（jqueryのfunctionメソッドとval()メソッド）
3. 取得したデータをajaxでリクエスト送信（表示したいURLにではなく、中間アクションへ送る）
4. リクエストされ、ルーティングを通り、指定したアクションを稼働し、このアクションから表示したいページのアクションへrenderするようにする
5. 表示したいアクションにデータが届いたら、done()メソッドを使って、表示する処理を決め、ビューにその結果を表示するコードを書く
①ここではユーザー一覧を例にとる
◍先ず、userのindexビューに検索窓を設置
```
<input type=form id="form" placeholder="ユーザー名を入力してください" style="width: 250px;"/>
```
◍次に、jsファイルを用意（今回は、javascriptディレクトリ内に設置：このファイルが有効になるためには、application.jsでファイル名を読み込み、jqueryをrequierする）
```
$(document).on('turbolinks:load', function(){ 
    $(document).on('keyup', '#form', function(e){ 
        e.preventDefault(); 
        var input = $.trim($(this).val());
～～～～～～～
```
◍ajaxメソッドを追記
```
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
```
⇒URLについては、後でルーティングで作る
（一度別のアクションに飛ばして、そのアクションから表示させたいアクションへ飛ばす。この中間アクションにビューは要らない）
◍ルーティングを設定して、usersコントローラーにsearchアクションを作る。
```
resources :users, only: %i(index create destroy edit update) do 
    collection do 
      get 'search' 
    end 
  end
～～～～～～～～～～～～～
def search 
  @users = User.where('name LIKE(?)', "%#{params[:keyword]}%")  
  respond_to do |format|  
  format.json { render action: :index, json: @users }  
  end 
end
```
⇒whereのlike検索の第二引数に使うワイルドカードで検索の一致の仕方を変えられる
完全一致なら、like検索の％を両方外すか、下記の方法もある
```
@jsusers = User.find_by(name: params[:keyword])
```

②ユーザー管理一覧のビューに検索結果を出したい場所にクラス名付きのulタグを記述
◍jsファイルのajax()メソッドの後にdoneメソッドでulタグの中にsearchアクションから送られたデータを元にliタグを入れるコード記述
```
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
⇒remove()メソッドは、検索して引っかかったliがどんどん増えていかないために付ける。
⇒つまりは、コントローラーの検索の仕方と、入力されていく文字をeachで回していき完全一致かlike検索で表示する。

★検索窓で入力が空になると全ての結果出でしまう問題について
◍検索時に文字が入力されている時はきちんと表示されるが、その文字を消して空にした時に全ての検索結果が出てしまうことについては、if文で入力文字あるなら（if(input)）表示をして、空なら（else）liタグを消す流れにすれば良い
```
$(document).on('turbolinks:load', function(){ 
    $(document).on('keyup', '#form', function(e){ 
        e.preventDefault(); 
        var input = $.trim($(this).val()); 
         
        if(input){　　＃inputがtrueなら（文字があるなら） 
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
        } else {　　　＃文字がある以外なら（文字が無いなら） 
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
    });   
});
```

★仕上げ
```
<table class="table table-bordered table-warning" style="width: 450px; margin-left: 55px"> 
   <tr><td>
　　　<strong>『ユーザー検索』</strong><input type=form id="form" placeholder="ユーザー名を入力してください" style="width:250px"/>
　 </td></tr> 
</table> 
<table id="result" class="table table-hover table-bordered table-sm table-dark mb-3" style="width: 450px; margin-left: 55px" > 
</table>
～～～～～～～～～～～～ ～～～～～～～～～～～～
.done(function(data){ 
     $('#result').find('tr').remove(); 
     $(data).each(function(i, user){ 
     $('#result').append('<tr><td>'+ '◆：' + user.name + '</td></tr>') 
     });  
   }) 
} else { 
    ～省略～   
.done(function(){ 　　　　　　　　　　　　　＃タグを消す方
     $('#result').find('tr').remove();   
})

```
◍構造について
⇒検索されたユーザーが分かりやすようにtableタグの中にapped()メソッドを使ってtrタグをとtdタグを入れるようにした。tableクラスの中にtableクラスをネストは出来ないので、検索窓用のtableタグと結果表示用のtableタグあり。trタグが増えると下に表示されていくのでそれでよい。
◍ｃｓｓについて
⇒このファイルには、上にもう一つのメインtableがあるが、bootstrapのtableクラスを指定するには、tableという名前ではないといけないので、ユーザー検索のtableに関しては、直接タグの中にstyleを指定する


①Vue.jsを使う
⇒rails中心
⇒Vue.jsとrails
https://hajimeteblog.com/vue-rails/
◍テックピットの大二郎さんのVue.js練習
②grape（rails5限定っぽい）
③railsのapiモード
Use an API with Ruby on Rails



仮メモ
- マークダウン　＃離す
- vscodeのマークダウンのプレビューが少し嘘注意
- markdownlint良し




～あとは～
- githubに削除としてファイルがのこってしまう
- そのブランチで違うブランチのファイルを気付かず変更し、プッシュしてしまったとき
- キータまとめ
- heroku



◆最終確認
①read me確認
◍バージョンと簡単な使い方が書いてあれば。DEMOのgifファイルは欲しい。
◍ライセンス確認（違反していないか）
⇒正直OKかどうかは、、herokuに出すくらいなら大丈夫、、MITライセンスでも他人のコードがMITじゃなかったらとかあるが。多くの人が使わなければ、、
②github関連
◍gitignoreに.envファイル（メーラー機能を使っているなら）とconfigのmaster.keyファイル（デフォルトでgitignoreにあり）
◍pushする場合、リモートはpublicにすること（プライベートだと相手が見えない）
③partialできるか
◍render駆使
④heroku
⑤記録残し
⑥ＳＥＯ対策









＝＝cssの設定＝＝
☆costom
●bodyにfont-family一番好きなserifと崩れないためのオプション追加
●navbarにあるbg-ligthというので真っ白くなり、cssとかで色を指定しても変わらないので外す！navbarクラスにbackgroundで色付け
＝＝疑問＝＝
●後から追加するreferencesはforeign_keyの記述がないがいいのか
◍javascriptのnew Arrayに（）が無い
＝＝勉強＝＝
●N+1問題
使える質問
●２－４、２－５、５－３