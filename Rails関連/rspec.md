# rspecについて（テスト用のライブラリ:テストフレームワーク）

## 概要

⇒日本において第一人者である和田さんのTDD（テスト駆動開発）の派生がBDD（振舞駆動開発）のテストフレームワークがrspec。動く仕様書（spec）として自動テストを書くという発想。

### capybaraについて

⇒webアプリケーションのE2E(End-to-End)テスト用フレームワーク。minitestやrspecと組み合わせて使い、javascriptのテストもできる。headlessブラウザで操作できる。
🔺注意🔺：デフォルトドライバの:rack_testはjavascriptをサポートしないために、javascriptを含めたテストをしたい時は。ドライバを:selenium_chrome_headlessなどのドライバを使用する
🔶参考🔶：headlessブラウザとは、GUIの無いブラウザのこと（恐らく、本体を立ち上げなくても手動のように操作できる）
🔶参考🔶：capybaraはrailsのE2Eテストに使われてきたが、railsとの連携やDBの扱いに不安があった。以前は、capybaraを使ったE2Eテストとしてfeature specが利用されてきたが、今はsystem spec推奨。下記の機能が付いた。

* テスト時に自動でDBがロールバックされ、database_cleanerが要らない

* テスト失敗時にスクリーンショットを撮影してくれる。

* driven_byを使ってspecごとにブラウザを簡単に切り替えられる  

### factorybotについて

⇒テスト用データの作成のサポートするgemで、昔はfactorygirlで知られていた。テスト用のデータを作成するための機能として、RailsではFixture（フィクスチャ）という仕組みがあるが、このgemはその代替品。（p189）

## テストのメリット

⇒新しくコードを追加した時に、コマンド一つで通るか分かる。通らなければ原因を探る。
⇒gemやrubyのバージョンアップをした時に通るかどうか調べられる。
⇒リファクタリングした後に動くかどうか調べられる。
⇒想定しているエラーを起こせるか？どうかを調べられる。

## テスト実行コード

⇒全て実行：`bundle exec rspec`
⇒そのファイルを実行：`bundle exec rspec spec/system/note_spec.rb`

## 学習と準備

* system specという機能を理解する（速習Ｐ１８４～Ｐ１９４）

* [rails6のrspecエラー](https://qiita.com/amatsukix/items/578f85cf4565ca2a797c)
⇒gem 'rspec-rails', '4.0.0.beta3'をインストール

* [古いが参考に](http://vdeep.net/rubyonrails-rspec-factorybot-capybara)

* [伊藤さんのrails6における変更点](https://blog.jnito.com/entry/2019/10/25/053521)

* 🔺注意🔺：[databese_cleanerは入れない方がいいらしい。速習でも不要とあり](https://qiita.com/ham0215/items/7516117df87d2631e31d)

⓪上記を確認後、下記の順で構築する。  
🔺注意🔺：rspecのバージョンは`gem 'rspec-rails', '4.0.0.beta3'`にする。（速習でも同じ手順）  
[rspec準備](https://takumalog.com/2020/05/08/post-104/)

* rm -r ./testコマンドで消えるのは、プロジェクト配下のtestというディレクトリが消える。

* テストファイルの記述でFactoryBotというコード名の記述の省略については、、確かにあった方が何をしているか分かりやすいが、、build、create、newだけでその名前が付いていると考え慣れた方が速いかも

* テックピットより
⇒テスト用のDBとは自動テストを実行するときに利用する専用のDBの事。例えば自動テストで「全データが消えること」を確認するとき、開発中に利用しているデータが消えてしまっては困るので、開発中のデータと自動テスト用のデータの双方が干渉しないようする

```ruby
bin/rails db:migrate:reset RAILS_ENV=test
# テスト用のDBを最新の構成にする
```

①🔺注意🔺：実はまだ、capybaraという機能に設定を出来ていない。  
⇒railsにはプロジェクトを作った時にすでにインストールされているが、spec_helper.rbにcapybaraをrequireしただけではまだ足りない。

⇒エラーの状況としては、テストをするとカピバラが読み込まれていない。特に、visit login_pathのlogin_pathがnameエラーになるので、原因としてわかりにくいが、capybaraのvisitメソッドのvisit(URL)のやり方だと、エラーでvisitがnomethodになっており、カピバラが読み込まれていないことが分かる。その解決策のヒントが以下である。

[ヒント](https://qiita.com/terufumi1122/items/aefd6c965e9e946efc3b)  
🔺：capybara~DSLをやるとテスト結果にcapybara~とは出ないがテストは通る  
🔺：まず、テストファイルのtypeをsystemにすると、ちゃんとpuma capybara~と出てエラーが出る。ディレクトリだけをsystemという名前にしてもvisitがno methodというエラーになるので、rspecファイルのtypeが大事か  
🔺：ディレクトリをsystemにすると、その中のファイルがちゃんと色付けされる

🔶解決🔶

★最終的には、、

1. rspec以下のディレクトリをsystemにする
2. テストファイルの最初の記載のtypeをsystemにする。
3. bundle update rspec-rails capybara selenium-webdriverを打って、各機能を最新にする（直接的な策ではないかも）
4. これが決め手：
⇒webdriverのエラーの上に、Failure/Error: visit("http://localhost:3000/login")と出ていたので、普通のvisit login_pathにしたら、capybara pumaが出た状態でテストが通った！  
⇒これを考えるとvisit(URL)という手法が今のバージョンだと使えないのか。  
⇒因みに、rspec下のディレクトリをmodelsでrspecファイルのtypeもmodelだと、上記のcapybara~DSLをやるとテストは通るが、system specでは無いので、やはりsystemと記載した状態でテストが稼働するか確認した方がいい。

③スクリーンショットについて、、  
⇒system specとcapybaraでテスト失敗時にスクリーンショットが記録されるが、それは、プロジェクト下のtmpファイルにある。エディタによって、表示される、されないがあるので、エクスプローラーから見るのが良い。

④ 作成したspecファイルのpending "add some examples to (or delete) #{__FILE__}"は要らない  
⇒したがって環境構築を終えたら、どのモデルのデータをテストするかを考えるので（User、Note、Postなど）、ER図があるとテーブルを見られて便利かも

* テストデータの自動削除？（調べ中）
◍画像登録のテストなどをしていくとデーターが溜まっていく？らしいので、upload設定ファイルの画像が登録される場所を変えるなどの操作があるらしいが  
[画像データの自動削除](https://qiita.com/tmyn470/items/6355c252022e80d682d8)  
[テストデータはどこへ消えた？](https://qiita.com/a_ishidaaa/items/b17ca8fa1a50ed5c3802)  

* [javascriptの設定とやり方](https://qiita.com/koki_73/items/ffc115ed542203161cef)

### factorybotの編集

★factorybotに関して、specというディレクトリができたら`factories`というディレクトリを自分で作ってもいいが、
⇒例えばUserモデルの登録のテストをするなら、`rails g rspec:model User`というコマンドできちんとしたファイル名で各ファイルの最初の走り書きも付けてくれる。（その代わり、作成されるファイルとディレクトリは、この場合specディレクトリの中にfactorybotの他にmodelというディレクトリ名で作られるので注意）
⇒また、factorybot単体で作るなら、`rails g factory_bot:model user`で出来るみたい

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

## テストファイルの編集

★前知識

* 最初にspec_helperはrequireする

* 最初の記述のtypeは基本system

* factorybot時の作成や通常のデータの作成はcreateを使う。.newで（）内にデータを書くときには、コンマが必要

* createやnewを変数に代入する場合、それを後で使うなら「＠」を付けると使いまわせる。付けないと他の場所で使えない。後は、＠を使わない変数を使う場合、スコープを考えてit文を作るなら、同じ変数データを使うにしても、もう一度.newなど記述をしないといけない

* テストを実行するときに、そのファイルにcapybaraのメソッドが使われてない時は、ターミナルにcapybara pumaと出ない

* .newで自身でデータを作成する時とfactorybotでデータ作成を行う違いについて。同じメールアドレスの登録が出来ないことを検証するとき、factorybotで先に用意してしまうと、そもそも最初から同じデータが作られてしまうので、コード自体通らない。流れの中でデータを作りたいなら、factorybotを使わないで自身で順番に上から.newでインスタンスを作っていくと、その流れに沿って検証を行える。
⇒🔶重要🔶：.newは空のインスタンスなのでcreateでテストが通ることもあった。データの作成は基本２つ！
★`@note = create(:note, name: "rspecテスト", user: user_a)`と書いてcreate(:ファクトリー名, ........)
★`Post.create( caption: "test", user_id: user_admin.id, id: 10 )`と直接モデルからcreateする

* letは、decribeかcontextの配下ではないと効かない！it配下では使えない

* 原則として「1つの example につき1つのエクスペクテーション」で書いた方がテストの保守性が良くなる。

* letは遅延評価である。letで定義されたメソッドが、結果までに呼び出されないとエラーになる

* 画像の呼び出し方は、`Rack::Test::UploadedFile.new(File.join(Rails.root, '画像ファイルがある場所のパス'))`
⇒specディレクトリ内にfixturesというディレクトリを作成して、そこに画像を置く
⇒[ここに基本あり](https://nanayaku.com/rails-rspec-carrierwave/)  

```ruby
before  do
      @photo = Photo.create(
        image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/forest.jpg')),
        post_id: post_admin.id
      )
      visit login_path
      fill_in "メールアドレス", with: user_admin.email
```

### requestタイプのテスト（get postといったメソッドを使う）

⇒[リクエストでログインする方法][https://qiita.com/tanutanu/items/14b0a1729069b53aa5b8]
⇒[rspec下にsupportディレクトリを作って、オリジナルメソッドを使えるようにする](https://qiita.com/necojackarc/items/17bbeae646e331eb5649)
⇒これに追加で、rails_helperファイルのRSpec.configure do |config|下にconfig include モジュール名を記述

* 自身でspecディレクトリにsupportというディレクトリを作って、そこにオリジナルメソッドを記述するためのファイルを作る。

```ruby
# module名も自身で作成
# session_params～の流れは、rquest specでのデータのやり取り
module LoginModule
  def sign_go(user)
    session_params = { session: { email: user.email, password: user.password }}
    post "/login", params: session_params
  end
end
```

* 次にrails_helperの下記のコメントアウト外して、ディレクトリ順（パス順）になるように作成したファイル名を当てはめる

```ruby
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
```

```ruby
Dir[Rails.root.join('spec', 'support', 'login_module.rb')].each { |f| require f }
```

* 最後にrails_helperの中のconfigの中に以下を記載

```ruby
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryBot::Syntax::Methods
  config.include LoginModule #ここを記載してメソッドを有効にする
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
```  

### mailerspecのテスト(メール用のマッチャを使うには)

config/environments/test.rbの中で、

```ruby
config.action_mailer.delivery_method = :test
```

とあるが、これのおかげでspec内で`ActionMailer::Base.deliveries.last`というコードでActionMailerインスタンスを取得できる。`ActionMailer::Base.deliveries.last`の戻り値を変数か（@mailなど）subject入れて使う。  
⇒このメソッドは、必ず、deliveriesのあとに何かしたら付けないとエラーになる。これでメール情報を取得できるので、マッチャと組み合わせてテストする。

★actionmailerのメソッド一覧

* ActionMailer::Base.deliveries.last(最後に送信されたメールを取得)

* ActionMailer::Base.deliveries.last.body(最後に送信されたメールの本文を取得)

* ActionMailer::Base.deliveries.first(最初に送信されたメールを取得)

★メール専用のマッチャを使うには

①`gem email_spec`のインストール

②rails_helperに「require"email_spec"」を記述（つけなくてもなぜか動く）

③必ず、rails_helperに

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

⇒無事動くと

```ruby
it "宛先へ送られている" do
          mail.deliver_now
          expect(open_last_email).to deliver_to(ENV["LOGIN_NAME"]) 
      end

      it "記入した件名が記載されている" do
          mail.deliver_now
          expect(open_last_email).to have_subject("【willnote】webサイトよりお問い合わせがありました") 
      end
```

⇒deliver_toやhave_subjectのマッチャが使える。

★email_spec関連のメソッドとマッチャ（expectの()内でこのメソッドを使わないとマッチャも使えないらしい）

* `open_last_email`(email_specのメソッドらしい)
⇒[公式](https://github.com/email-spec/email-spec/blob/master/lib/email_spec/helpers.rb)

★ActionMailerの過程で作成したメソッドを直接呼び出す

```ruby
# メールテストファイル
RSpec.describe Contact, type: :mailer do
    after { ActionMailer::Base.deliveries.clear } 
    let(:new_mail) { Contact.create(name: "test", email: "test@au.com", content: "日本語テスト") }
    let(:mail) { ContactMailer.received_email(new_mail)}

    it "メールが実際に送られているか" do
        expect do
            mail.deliver_now
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

# contactコントローラー
def complete
    @contact = Contact.new(contact_params)
    if params[:back]
      render action: :new
    else
      ContactMailer.received_email(@contact).deliver_now   
    end  
  end
```

⇒この`received_email`は以下の`app/mailer/contact_mailer.rb`というActionMailerでジェネレートした時に作成したクラスのメソッドを持ってきている）
⇒`deliver_now`はAcitonMailer時のメールを送るメソッド

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

⇒🔺注意🔺：deliver_nowメソッドは、letの中に入れてしまうと（letではなくてもitの外に記述されると）リアルタイムで送れないので、テスト結果にエラーが確か出る？


### メソッド・マッチャの使い方

★changeマッチャ
[参考](https://qiita.com/paranishian/items/51d3742b7095aa7744ca#%E5%8F%82%E8%80%83)  
⇒expect内のデータがブロックではないと使えない

```ruby
expect( Proc.new {user_b.destroy}).to change{ Note.count }.by(-1)
expect( Proc.new {user_b.destroy}).to change{ user_c.notes.count }.by(-1)
#どちらでも通る
```

★postで登録する場合のparamsの渡し方

```ruby
post users_path, params: { user: { name: "tarou", email: "abc@au.com", admin: false, password: "password", password_confirmation: "password" }}
```
