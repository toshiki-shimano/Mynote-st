# Jquery関連

## 前知識

★取得順番

①イベントを設定したい要素を取得する  
⇒$(  )メソッドとCSSのセレクタを使う

②その要素にイベントを設定する  
⇒jqueryのonメソッドを使用する

③イベントが発生した時の処理を実行する
⇒その時によって違う処理

***

* $()メソッドは、jqueryオブジェクトという独自のオブジェクトになる。つまり、メソッドとプロパティを持っているので、$(  )の中に入った要素に対してjqueryのメソッドとプロパティを使うことが出来る

* トラバーサル用のメソッド：「行ったり来たり」という意味で、取得した要素から「次の要素」、「親要素」、「子要素」などを相対的な位置関係で別の要素を取得する機能  
⇒next()メソッド

* jqueryの中には、プラグインが必要なメソッドもあるので下記を参考に共通ビュ―のheadタグの中でjqueryのＵＩの方をlayoutビューに読み込んでおく
[参考サイト](https://qiita.com/hajimete/items/64a25c08e2f5a3cf929c)

***

### 基本

★HTMLが読み込まれたらfunctionの中を実行する。（この形がテンプレート）

```javascript
$(document).ready(function() {
  //処理
});

$(function(){ //(document).readyの部分がそのまま省略された
  //処理 
});
```

⇒この二つの動作は同じであり、どっちでもよし。上はready()に囲まれ、下はドルファンクションに囲まれている。  

⇒jQueryのreadyイベントとは、DOM（HTML）の読み込みが完了した際に実行されるイベント。readyは省略が可能で、上記の2つのコードは同じ意味を表す。

```javascript
//jqueryを読み込み済み
<script> 
'use strict'; 
$(document).ready(function() {

    $('.submenu h3').on('click', function() { 
        $(this).next().toggleClass('hidden'); 
    }); 

});
</script>
～～～～～～～～～～～～
//通常のイベントの起こし方
～～～～～～～～～～～～
document.getElementById('datasearch').onsubmit = function() {  
    const search = document.getElementById('datasearch').word.value;  
    document.getElementById('output').textContent = `${search}を検索中`;  
}  
```

### jqueryメソッド

★$()メソッド：（ ）内にCSSセレクタを含めると、それにマッチする要素を全て取得する（全てなので最初の１つだけではない。querySelectorAll()メソッドとほぼ同じ。document.querySelectorAll(~)）  
(querySelectorAll()メソッドはNodeListオブジェクトとして生成される。$()メソッドは、jqueryオブジェクトという独自のオブジェクトになる)

★on()メソッド：（ ）内に２つパラメータを用意。１つは、イベント名。２つ目は、ファンクションで固定

```javascript
$('.submenu h3').on('click', function() {  
      $(this).next().toggleClass('hidden');  
});
```

★next()メソッド：イベントが発生した次に出てくる要素を取得（次の弟要素を取得：子要素ではないよ！）

```html
<!-- ここでは、submenuのh3を取得していて、そのh3の次の<ul>要素を取得している -->
<div class="submenu"> 
    <h3>1. 初めて使うとき</h3> 
    <ul class="hidden"> 
        <li><a href="">- 概要</a></li> 
        <li><a href="">- インストールする</a></li> 
        <li><a href="">- アカウントを登録する</a></li> 
        <li><a href="">- アンインストールする</a></li> 
    </ul> 
</div>
～～～～
<script>  
'use strict';  
$(document).ready(function() { 
    $('.submenu h3').on('click', function() {  
        $(this).next().toggleClass('hidden');  
    });  
}); 
</script>
```

★toggleClass()メソッド：取得した要素に（ ）内のパラメータで指定されているクラス名が付いていなければ追加して、付いていれば削除する。

★html()メソッド：HTML要素を取得したり追加・書き換えを行える。
⇒[参考](https://www.sejuku.net/blog/38267)

```html
<p>こんにちは</p>
```

⇒このp要素にあるテキスト文字を取得したりp要素をa要素に変更したり、1つだけのp要素を3つに増やしたり、完全に削除することも簡単に実現できる

* 対象要素.html( 文字列 )～追加する～

```javascript
$('body').html('こんにちは！'); //ブラウザにこんにちは！と出る
$('body').html('<h1>こんにちは！</h1>'); //タグの状態も含め、要素としてhtmlが表示される。おそらくbodyに何か先にある場合丸々変わる
```

* 対象要素.html(`空欄`)～取得する～（html()メソッドで要素のコンテンツを取得）

```html
<body> 
<p>こんにちは</p> 
<a href="#">サンプルリンク</a> 
<script> 
    const result1 = $('p').html(); 　
    const result2 = $('a').html(); 
    console.log( result1 ); 
    console.log( result2 ); 
</script> 
</body><!--コンソールの結果では、こんにちは と サンプルリンク が出る-->
```

* 対象要素.html( 文字列 )～丸々入れ替え～
🔶重要🔶：対象要素の**中に**入れる。中が書き変わる。
  
```html
<body> 
<div> 
    <h1>タイトル</h1> 
    <p>サンプルテキスト</p> 
    <a href="#">リンク</a> 
</div>   
<script> 
    $('div').html('<p>こんにちは</p>'); 
</script> 
</body>
<!-- 丸々divの中身が<p>タグのこんにちはだけになる -->
```

★parent()メソッド：親要素を取得する  
⇒parent().parent().parent()と一つ上の階層を取得していける

★find()メソッド：タグやclass、idを検索するjQueryの機能(idが無いタグなども参照できる)

```html
<div id="target2">
    <h1>見出し</h1>
    <div id="target"></div> 
</div>
～～～～～
$("#target").parent().find("h1");
```

⇒取得したその要素の親要素（target2）を取得。find()でその中のセレクトされた要素と同じ`target2`内のh1タグを取得（つまり、idが無いタグに使う）

### jQuery UI のプラグイン

★ Sortable()メソッド：

```html
<table> 
      <thead id="test2"> 
        <tr id="test3"> 
         <th>Name</th> 
         <th>Salary</th> 
        </tr> 
      </thead> 
      <tbody id="test"> 
       <tr><td>Bloggs, Fred</td><td>$12000.00</td></tr> 
       <tr><td>Turvey, Kevin</td><td>$191200.00</td></tr> 
       <tr><td>Mbogo, Arnold</td><td>$32010.12</td></tr> 
       <tr><td>Shakespeare, Bill</td><td>$122000.00</td></tr> 
       <tr><td>Shakespeare, Hamnet</td><td>$9000</td></tr> 
       <tr><td>Fitz, Marvin</td><td>$3300</td></tr> 
      </tbody> 
    </table> 
  </div> 
</div> 
<script> 
'use strict' 
$(function(){ 
    $('#test, #test2, #test3').sortable({ 
      cursor: "move" 
    }); 
}); 
</script>
```

* テーブルタグの`<tr>`と`<th>`と`<td>`タグは動かせるが、`<table>`タグは動かせない

* sortableプラグインのオプションをつけるには、sortable（｛～｝）～にcursor:"move"など

★使えそうなオプション  
⇒cursor:"move"  
⇒revert: true：ドロップした時に滑らかに動く  

★さらにこのプラグインにはイベントがあり、その中にstartとstopがあり、stopはソートした後にイベントを起こす

◍cssに下記を付けておけば移動できるか判断しやすい

```css
tr:hover {
    cursor: move;
}
```

★disableSelection()メソッド：テキストを選択できないようにする場合に便利。たとえば、テキストをオンにしたままドラッグアンドドロップ要素を作成する場合、ボックスをドラッグしようとしたときに誤ってボックスのテキストが選択されると使いずらい。

★$.cookie()メソッド  
⇒[cookieオブジェクトの取得の仕方](https://www.sejuku.net/blog/54153)

★prependTo()メソッド  
⇒似たものでprependメソッドがあるので注意  
⇒[この解説が全て](http://semooh.jp/jquery/api/manipulation/prependTo/content/)

```javascript
<body>
  <div id="foo">FOO!</div>
  <span>I have something to say... </span>
</body>
～～～～
$('span').prependTo('#foo');
/*spanタグの！  要素の中の！直前に入れる*/
/*結果は：I have something to say...FOO!*/
```

★attr()メソッド  
🔶重要🔶：簡単に言うと、対象としたオブジェクトの属性（idやclassやsrcなど）に第2引数を入れると、その内容に元ある内容へ丸々入れ替えることができる。  
⇒attr()メソッド：jqrueryオブジェクトのHTML要素の**属性を**取得したり設定することができる  
⇒removeAttr()メソッド：属性を削除する  
⇒`<a class="link" href="##">これはリンクです</a>` の`<a>`タグのclassやhrefなどの属性を操作できる

```html
<p id="sample">こんにちは</p> 
～～～～～～～～～
<script> 
const result = $('p').attr('id', 'text');   
console.log( result ); 
</script>
~~~~~
<!-- 結果：<p id="text">こんにちは</p> -->
<!-- 第一引数だけだと、sampleが取得できる -->
```

⇒これは、pタグのid属性の中身を取得しており、**第2パラメーターに書けば、その属性変えることができる**  
⇒また、このpタグにidが無ければ、今度はattr()メソッドの第1パラメーターと第2パラメーターを使って、id属性にtextを入れることもできる（`<p id="text">こんにちは</p>`）  
⇒第1パラメーターは属性を指す（指定パラメーターがあれば変更しなければ追加）  
⇒第2パラメーターは、含めるパラメーターを指す  

★append()メソッド  
⇒指定した子要素の最後にテキスト文字やHTML要素を追加することができるメソッド  
⇒下記のコードは、クリックイベントがないのでそのまま画面に追加表示される  

```html
<body>
<p>こんにちは！</p>

<script>
    $('p').append('太郎さん。');
</script>
</body>
// 結果：<p>こんにちは！太郎さん。</p>
```

* preventDefault()メソッド
⇒submitイベントの発生元であるフォームが持つデフォルトの動作をキャンセルするメソッド。この場合のデフォルトの機能は、フォームの内容を指定したURLへ送信するという動作。form要素に送信先が指定されていない場合、現在のURLに対してフォームの内容を送信するらしい。

```javascript
formElement.addEventListener("submit", (event) => {
    // submitイベントの本来の動作を止める
    event.preventDefault();
    console.log(`入力欄の値: ${inputElement.value}`);
```
