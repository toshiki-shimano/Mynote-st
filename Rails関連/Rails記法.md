# Railsにおけるメソッドや記法

①link_to  
`<%= link_to "仮のボタンです", "#", class: "btn btn-primary" %>`  
（link_to キャプション リンク先のヘルパーパスやurl a要素（タグ）につける属性：ここではcssクラスを指定）  
⇒画像や要素をまるまるリンクにしたい時は、キャプションを書かず、link_to~do~endで囲む

```html
<%= link_to list_card_path(list, card), class: "cardDetail_link" do %>
     <h3 class="card_title"><%= card.title %></h3> 
<% end %>
```

②パーシャル（共通化）
`<%= render "partial/header" %>`  
⇒ビュー配下に共通化したいファイルを入れるためのディレクトリを作成。その中に、アンダーバーから始まる、ファイルを作成。そこに共通化したいコードを移して、元のファイルのコードは消して、そこにrenderを打つ。

③form_with  

⇒form_withの次の引数である、modelやURL、Scopeなどの違いを理解が大切である。ルーティング関わってくる。
<https://pikawaka.com/rails/form_with>（まずこれが基本）

## 前提理解

◍データベースに値を保存するためには、model: モデルのインスタンス（@noteなど）の形式。（コントローラーでは、newアクションに@note、createアクションに@noteを生成している。それをビューのform_with内で使い、このインスタンスにユーザーが入力したものが@noteに入っていくイメージ）  

◍form_forはデータベースに保存するとき、form_tagは保存しないときに使っていた。  
⇒保存するかしないかの目的をはっきりさせることが重要  

◍form_withはHTMLで言えば、formタグ（actionやmethodという属性を持った）の役割であり、HTMLでは、formタグでmethodを決めて（HTTPリクエスト）、actionに書かれたURLに飛ばす。飛ばす内容はformタグの中にｐタグなどを書き、inputタグでsubmitする。
⇒コントローラーで.newしてインスタンスを作って、その中に入力された値を入れて（ビューでそのインスタンスを指定することによって、このモデルに保存したいという指定をしている？）create保存する？

◍モデル同士でネストにある場合（postとlikeがアソシエ状態で、ルーティングがpostの中にlikeがある場合）、コントローラーのアクションでインスタンスをそれぞれ作ることがある。（今回postとphotoではこうしていないが、一緒にカラムを保存できるようにヘルパーを使っている）

```ruby
def create 
        @comment = Comment.new(comment_params) 
        @post = @comment.post 
        if @comment.save 
            respond_to :js 
        else 
            flash.now[:alert] = "コメントに失敗しました" 
        end 
    end
```

⇒結果、ピカワカの方では、form_withの次の引数でmodel: [@post, @photo ]など書くときもあり。上記では、@commentが作られた際にpost情報を入れている。
