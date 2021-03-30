# Javascriptについて

## 前知識

* bracketsがjavascriptに対応しているみたい。ライブプレビューの何も書いてないのに出るfabiconエラーは、下記のコードをheadに入れる  
⇒`<link rel="icon" href="data:;base64,iVBORwOKGO=" />`  
⇒[参考](https://python5.com/q/nfckbznk)
⇒また、jsの外部ファイルは読み込めないみたい、html本体のファイルに書き込む。

* 参照とは：値を読み取ったり、変数の場合は書き換えたりすること

★コードの基本  
⇒console.log(number);  
⇒（オブジェクト、メソッド、パラメーター、文章の終わりセミコロン）

★オブジェクト（consoleやdocumentやwindow）  
⇒ブラウザなどに見える機能それぞれを指す（window全体、コンソール、使われているhtml要素、url欄のlocationなど）

⇒オブジェクトが持っているメソッドは決まっている。windowオブジェクトは、alertメソッドを使えるが、consoleオブジェクトのlogメソッドは使えない。

⇒全てのオブジェクトは、メソッド以外にプロパティというのものを持っている

* 〇〇オブジェクトの□□は△△である  
* 〇〇オブジェクトの□□を△△にする  

⇒などの□□がプロパティで△△がプロパティ値

★メソッド（オブジェクトに命令を出すモノ）  
⇒メソッドの後には必ず（）を付ける！

★プロパティ  
⇒そのオブジェクトの状態を表すモノ（例えば、locationオブジェクトはブラウザのURLを担っているが、その状態を指し示すなら、hrefプロパティというのを指定して、そこに新しいURLを入れれば、URLが変わる））  
⇒textContent：要素のコンテンツを表すプロパティ

***

⓪consoleオブジェクト  
⇒log()メソッド：コンソールでプログラムが正しく表示されるか見る

```javascript
console.log('こんにちは')
console.log(number)
```

①windowオブジェクト  
⇒alert()メソッド：ブラウザが読み込まれたら上にダイアログボックスを表示する

```javascript
window.alert('変更')
//ページを読み込むと上に表示される
```

⇒confirmメソッド：ダイアログボックスに「はい」と「いいえ」がある形式  

* alertメソッドと違いリターン（実行結果）を返してくる。（trueかfalseを返す）  
* if文の最初の（）の条件にも使える  

```javascript
window.confirm('いいですか？')
```

⇒prompt()メソッド：ダイアログにテキストフィールドを作り、その入力された値を保存する。このメソッドは、OKをクリックした時にリターンを返し、キャンセルを押したときは何も返さない

* 入力された値が文字列の時は、ifの条件の所をシングルで囲まないと認識されない

```javascript
const respond = window.prompt('helpを見ますか？') 
if(respond === 'yes') { //yesをシングルで囲む
  console.log('yesを返します'); 
} else if(respond === 'no') { 
  console.log('falseを返します');
} else {
  console.log('それ以外を返します'); 
}
```

②documentオブジェクト  
⇒getElementByIdメソッド()：任意のHTMLタグで指定したIDにマッチするドキュメント要素を取得するメソッド。指定したidのhtml**要素**を取得(ulタグを取得したら、要素はliタグも含める)

* さらにこれで取得された要素をjavascriptでは`Elementオブジェクト`として扱い、このオブジェクトも独自のメソッドとプロパティを持つ。`textContent`は`Elementオブジェクト`のプロパティである。

⇒textContentプロパティ：これを付けると、＝で取得したhtml要素のコンテンツ部分（タグの中身）を変えることができる。代入しないと、読み取る

```html
<p id="choice">ここに日時を表示します</p>
<script> 
'use strict';       
document.getElementById('choice').textContent = '変更'; //書き換える
document.getElementById('choice').textContent; //書き換えるのではなく読み取る
</script>
<!-- これは、idを取ると分かっているので、.choiceや#choiceなどとしなくてよい -->
```

* textContentプロパティは、要素のコンテンツを書き換えたりできるので、tdタグに何もなくても、連想配列のデータ値を入れることができる

```html
<table> 
   <tr> 
     <td id="title"><!--ここにjsbookと入る--></td>
～～～～～～
<script> 
'use strict'; 
let book = {title: 'jsbook', price: '1000円', stock: 3}; 
document.getElementById('title').textContent = book.title;
</script>
```

⇒querySelector()メソッド：（ ）内に書かれたセレクタにマッチする要素を取得する。ここでいうセレクタとは、CSSで最初に書く、#notePageとか、.pagecontentとか、body、htmlといったCSSセレクタを指す。つまり、形状CSSのセレクタを指定しているみたいな感じ。  

* querySelector('option[value="index.html"]')のこの場合の[~~]の中は、CSSでは属性セレクタと呼ばれる。  
(注意は、optionというセレクタが複数あった場合には最初にマッチしたものしか読み取らない)

⇒querySelectorAll()メソッド：（ ）内で指定されたCSSセレクタにマッチする要素を全て取得

* このメソッドは取得した要素は配列みたいに格納されるが配列オブジェクトではない。取得された要素は、`NodeListオブジェクト`として生成されるので、配列オブジェクトのメソッドは使えない。`forEach()メソッド`は一応使えるみたい

⇒createElement()メソッド：（ ）内にあるタグ名の`要素`を生成して。メモリに保存するメソッド

③Elementオブジェクト
⇒textContentプロパティ：＝で取得したhtml要素のコンテンツ部分（タグの中身）を変えることができる。代入がなければ、読み取るメソッドになる

```javascript
document.getElementById('choice').textContent = '変更'; #書き換える
```

⇒insertAdjacentHTML()メソッド：所得した「要素」の前か、その要素の中に（子要素として）別の要素を入れることができる。  
（insertAdjacentHTML（'挿入する場所' ,  タグが付いた状態で整理されたデータ））

```html
<h1>やることリスト</h1> 
<ul id="list"> 
<!-- この中にbeforeendで要素を入れる（親要素である<ul>の中に<li>を含めた要素を入れる） -->
</ul>

<script> 
'use strict'; 
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を買う', '掃除をする']; 
for(let item of array) { 
    const listpro = `<li>${item}</li>`;  //ここでちゃんとタグを付けておかないと反映されない
    document.getElementById('list').insertAdjacentHTML('beforeend', listpro); 
} 
</script>
```

* `'beforeend'`は、取得した要素（ulの）の子要素として挿入。（取得した要素の終了タグの前に挿入。ここで言う`</ul>`の前）  
(for～ofで一つ一つのデータに`<li>タグ`を付けていく)

⇒removeChild()メソッド：既にあるHTML要素の子要素か孫要素を削除する。

⇒innerHTMLプロパティ

```html
<body>
    <p id="test">初めてのJavaScript勉強中だよ！</p>
    <script>
      var elem = document.getElementById("test");
      elem.innerHTML = "<span style='color: blue;'>span要素に変更したよ！</span>";
    </script>
    
  </body>
```

* htmlタグを含めた要素を丸々採取するには、documentというオブジェを用意する。この場合、空の`document`に`getElementByIdメソッド`を使って、上のpタグ全体を取得して、elemという変数に入れる。そして、innerHTMLプロパティを使用すれば、要素の中身を変更する事が出来る

★Elementオブジェクトの各イベントプロパティ（ページの下参照）  

* onsubmitイベントプロパティ  
* onchangeイベントプロパティ  
* onclickイベントプロパティ  

④Mathオブジェクト（ｐ１８０）  
⇒random()メソッド：何も書かなければ、０～１のランダムの数値を生み出す

* 下記のランダムの範囲は１～３０。後ろの +  1が無ければ、範囲は０～３０。 *  30が無いと範囲は０～１になる。

```javascript
const attack = Math.floor(Math.random() * 30) + 1
//floorで小数点を切り捨て、ちゃんと+1が整数で入るようにしている
```

⇒floor()メソッド：( )内の数値の小数点以下を切り捨てる

⇒PIプロパティ：円周率を表示する

```html
<p>円周率は<span id="pi"></span></p> <!-- 3.141592653589793 -->
<p>普通に切り捨てると<span id="cutpi"></span></p> <!-- 3 -->
<p>第二小数点で切り捨てると<span id="secondcutpi"></span></p> <!-- 3.14 -->
<script> 
'use strict'; 
document.getElementById('pi').textContent = Math.PI 
document.getElementById('cutpi').textContent = Math.floor(Math.PI) //小数点以下を切り捨てる
       
function point(num, digit) { 
  const pinum = 10 ** digit; //10の2乗
  return Math.floor(num * pinum) / pinum; //100を掛けて314になり、100で割り3.14になる
} 
document.getElementById('secondcutpi').textContent = point(Math.PI, 2); 
</script>
```

* もし円周率を第二小数点で切りたい時、その機能はないので、第2小数点なら１００を掛けて、その状態で小数点以下を切り捨て、
その後１００で割ればよい  
⇒digitは第何の小数点で切りたいか。第３なら、10の3乗で1000で掛ける。円周率は3141.5~になるので、小数点以下を切り捨て、3141を1000で割れば3.141になる

⑤配列オブジェクト：配列が入ったデータそのものや変数を指す（constは全体を変えることはできないが、一部を変えることはできる）  
⇒push()メソッド：配列データの最後にデータを追加  
⇒unshift()メソッド：配列データに最初にデータを追加  
⇒pop()メソッド：配列データの最後のデータを削除  
⇒shift()メソッド：配列データの最初のデータを削除  

```javascript  
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を食べる', '洗濯をする']; 
array.push('歯医者に行く');
```

⇒forEach(function(item, index) {  処理内容 });メソッド：配列の各項目を繰り返し処理する。特徴的なのは、functionと引数がセットになっているところ。｛ ｝で書かれた処理が配列の各項目に全て実行される。itemに内容が、indexにはインデックスが入る。

⇒lengthプロパティ：配列の項目数を表す

⇒join()メソッド：配列の要素を繋げて文字列に変換することができる便利な機能。配列データに「join」メソッドを繋げるだけで、配列の各要素がすべて連結されて「文字列」として生成されるようになっている。

```javascript
var array = ['2017', '08', '03']; 
var result = array.join('-');   
console.log( result );
//結果：２０１７－０８－０３
```

* 配列の要素をそのまま連結したい場合は、引数に「空文字」を指定すればよい

```javascript
var array = ['今日の天気は', '雨', 'でした']; 
var result = array.join('');
console.log( result );
//結果：今日の天気は雨でした
```

⑥連想配列オブジェクト：javascriptではただのオブジェクトを呼んでいる（for~let~ofでは全て読み取れない）

```javascript
let book = {title: 'jsbook', price: '1000円', color: 'red', stock: 3}; 
book.title = 'rubybook'
console.log(book.title);
```

* インデックスの部分を呼ぶ時には、ドットを付けて呼ぶ。他にも、他の呼び方として、console.log(book['price'])という出し方もできる

* 代入の仕方は、ドットでプロパティを呼んで代入する。（book.title = 'rubybook'）

* `title:'jsbook'`の内、`title`をプロパティ名、`'jsbook'`がデータ値（プロパティ値）、全体でプロパティと呼び、さらにデータ値には`function()`を入れることが出来る

* 配列オブジェクトと違い、取り出される順番に順序がないらしい。

⑦Dateオブジェクト（最初に変数に入れて初期化しないといけない。newで新しいインスタンスすることによって初期化している）

* 現在の日時を取得する  
* 過去や未来の日時を取得する  
* 時間の計算  

★const date = new Date()：( )の中に何も入れない状態で作ると現在の時間が入る

* 以下は、現在の値を取得(getTime以外)

⇒getFullYear()メソッド：年を取得

⇒getMonth()：月を取得（この値だけ+1が必要。このメソッドだけは、実際の月-1の値が取得される）

⇒getDate()：日を取得

⇒getHours()：時間を取得

⇒getMinutes()：分を取得

⇒getSeconds()：秒を取得

⇒getTime()：1970年1月1日０秒からの時間をミリ秒で取得

```javascript
const hour = new Date().getHours() 
const minute = new Date().getMinutes() 
console.log(`${hour}時：${minute}分`)
```

* new Date()で得られるのは、現在の時間で今の時間表記に単位が直してある！また、時間を引いたり足したりするには、単位の一番小さいミリ秒に直して全体を引いてからもう一度最初の単位に直す必要がある。（ｐ１８３も参照）

⇒getTime()：1970年1月1日0秒からの今の時間をミリ秒で取得する。セッティングした時間もミリ秒にできるので、それらを計算することが出来る。

```javascript
function countdown(due) { 
    const now = new Date(); 
    const rest = due.getTime() - now.getTime(); //１６０１４７７９９９０００（未来）－１６０１４４５６０００００（現在）
～～～～～～～
```

* ミリ秒を各単位に直すとなぜか小数点が出てくるので、必要な単位まで割り算したら、一度小数点を切り整数にする。それから、余りを出す％で割ってあげる。一度整数に直すのは、あまりがきちんと出るようにするため！

```html
<div class="container">
<section>
    <p>いまから<span id="timer"></span>以内に注文すると50%オフ！</p>
</section>
```

```javascript
function countdown(due) { 
    const current = new Date(); 
    const rest = due.getTime() - current.getTime(); //設定した時間をミリ秒で取得して引き算
    //今はミリ秒なので1000で割ると1秒単位
    const sec = Math.floor(rest / 1000) % 60; //※ミリ秒を秒まで引き上げて、一度整数に直し、６０秒単位で割った余りが秒：ここでは５９
    const min = Math.floor(rest / 1000 / 60) % 60; //※秒に引き上げたら、単位もう一つ上に上げるので、分の単位６０でさらに割る。
    const hours = Math.floor(rest / 1000 / 60 / 60) % 24; 
    const days = Math.floor(rest / 1000 / 60 / 60 / 24); //日にちに2.1とかは無いので完全に小数点を切る
    const count = [days, hours, min, sec]; 
    return count; 
}

let goal = new Date();
goal.setHours(23); //ここでは、年、月、日は設定してないのでこれら３つは自動的に現在の日にちになる
goal.setMinutes(59);
goal.setSeconds(59);

function recalc() {
    const counter = countdown(goal);
    const time = `${counter[1]}時間${counter[2]}分${counter[3]}秒`;
    document.getElementById('timer').textContent = time;
    refresh();  
}

function refresh() {
    setTimeout(recalc, 1000);
}

recalc();//ここでrecalc発動
</script>
```

* 後に引数の中のファンクションを1秒ごとに実行するというsetTimeout()というメソッドがある  
⇒setTimeout（ファンクション、待ち時間（何秒ごとに実行するかという数値））  
⇒このメソッドの待ち時間はミリ秒単位なので１０００と打つと１秒ごとにという事になる。  
⇒このsetTimeoutのrecalcに()を付けてはいけないルールがある。理由はｐ１９２

⑧Stringオブジェクト：シングルやバッククオートで囲まれた文字列を指す  
⇒padStart()メソッド：（ ）の中は、（そろえる文字数、埋め合わせる用の文字）

⑨locationオブジェクト：windowオブジェクトと同じくブラウザに最初から組み込まれているオブジェクトであり、URLを調べたり、閲覧履歴を管理したりする機能がある  
⇒hrefプロパティ：今表示しているURLを書き換えて（location.href = 新しいURL）、その先に移動する

## 各イベントプロパティ

🔶重要🔶：イベントに代入するファンクションにはメソッド名はつけない。また、実行部分でreturnを使わない！

* HTML記法のinputタグに入力された内容をjavascriptで読み取るときは、inputタグのname属性から読み取る  
(`name="word"`で `たろう` と入力されたら、wordを参照して「たろう」を読み取る。formタグの中のselectタグにnameを仕込む時もある)

* 入力した内容を読み取るには、  
⇒（Elementオブジェクト.読み取りたいformの部品のname属性.value）  
で、valueプロパティで値を取得する

* 要素にイベントが発生して、そのイベントプロパティに続くfunctionにeventという引数を置くと、functionにeventオブジェクトが渡されるので、そのオブジェクトのメソッドを使うのことが可能になる。この引数に当たる（）の中の名前は好きな名前で大丈夫。つまり、わざわざ（event）にしなくて良い。引数に置いた名前がeventオブジェクトになる

①onsubmitイベントプロパティ：formタグのinputタグのsubmitが押された瞬間に（ページ移動する前に）発動する。

```html
<form action="#" method="#" id="datasearch"> 
   <input type="text" name="word"> 
   <input type="submit" value="検索"> <!-- 検索はsubmitボタンの名前-->
</form> 
<p id="output"></p> 
～～～～～～～～～～～
<script> 
'use strict'; 
document.getElementById('datasearch').onsubmit = function() { 
    const search = document.getElementById('datasearch').word.value; //valueプロパティ
    document.getElementById('output').textContent = `${search}を検索中`; 
} 
</script>
```

* Elementオブジェクト.onsubmit  =  function( )  {  実行したいこと  }  
（functionは基本メソッド名なし、引数無し）

* 先ず、form全体の要素を取得した後に、そのElementオブジェクトにonsubmitイベントを取り付ける。その実行部分で、form要素の中の絞ってさらにその中のword属性を読む！このままだと、ただの変数なので、wordの値を取得するためにvalueプロパティを扱う。その入力された内容を変数に格納して、outputのidを持つ要素のコンテンツにtextContentで入れる。

* ここで最後に、functionの引数にeventと書いて、次の行に`event.preventDefault();`を置くと、送信した時にそのページに移るという機能が動かないのでそのまま検索中というページで止まる。

アロー関数ならfunctionを省略してアローを付けるだけ

```javascript
document.getElementById('datasearch').onsubmit = (event) => { 
   event.preventDefault();
```

②onchangeイベントプロパティ：formに入力された内容が変わった時に発生する。テキストフィールドなら入力内容が変わった時、プルダウンメニューなら選択項目が変わった時に発生する。

```html
<html lang="ja">
～～～～～～～～
<form id="form"> 
   <select id="selector"> 
     <option value="index.html">日本語</option> 
     <option value="index-en.html">英語語</option> 
     <option value="index-zh.html">中国語</option> 
   </select> 
</form>
～～～～～～～～
<script>
'use strict'; 
const lang = document.querySelector('html').lang; 
//下記のは、ぺージに移動したときにその選択肢が選択済みになるようにするための処理
if(lang === 'ja') { 
    document.querySelector('option[value="index.html"]').selected = true; 
} else if(lang === 'en') { 
    document.querySelector('option[value="index-en.html"]').selected = true; 
} else if(lang === 'zh') { 
    document.querySelector('option[value="index-zh.html"]').selected = true; 
} 
document.getElementById('form').select.onchange = function() { //＃A
    location.href = document.getElementById('form').select.value; 
}
</script>
```

* プルダウンメニューが切り替わった時にそのURLに飛ぶようにする。つまり最初にページを開いたときは、まだプルダウンメニューは切り替わっていないのでイベントは読み込まれない。だから、最初にlang="ja"のページを開いたら、if文では、lang  === jaなので日本語の選択肢のselectedがtrueになる。

★このプルダウンメニューでは、ユーザーが選択肢を変えるとイベントが発生してそのURLには飛ぶ。日本語ページから英語ページに飛んだとして、、、もし、英語にselectedがされておらず、選択肢が日本語のままなら、英語のページで日本語を選んでも選択肢が変わらないので、イベントが発生しなくなり、ページ移動できなくなる。したがってその後戻れるようにするには、英語ページに飛んだ時に、英語の選択肢にselectedがtrueになっている必要がある。（P208）

⇒先ず#Aでは、form部品の中のselectorをnameとして絞り、その内容が変わったら、formのselectのvalueのurlを新しいurlとしてhrefプロパティに入れる。何かをきっかけに分岐を使いたいが、そこでhtmlタグのlangに目を付ける。ここの要素を読み取って内容で分岐させる。ただここには、idが無いので、タグ自体を選択して読み取るquerySelector()メソッドを使い読み取る。そこで用意していた３つのhtmlファイルの内、表示したファイルのhtmlタグがjaなら、そのoptionのvalueを読み取り、選択済みにするためにtrueを入れる（selected = true）

③onclickイベントプロパティ：取得された要素がクリックされた時にイベント発生（主に`<button>`タグの時や画像のクリックした時、スマートフォンでタッチをした時にも発生）

```html
#CSSは省略
～～～～～～～～～～～～
<div class="container"> 
<section> 
   <div class="center"> 
     <div> 
       <img src="img1.jpg" id="bigimg"> 
     </div> 
       <ul> 
          <li><img src="thumb-img1.jpg" class="thumb" data-image="img1.jpg"></li> 
          <li><img src="thumb-img2.jpg" class="thumb" data-image="img2.jpg"></li> 
          <li><img src="thumb-img3.jpg" class="thumb" data-image="img3.jpg"></li> 
          <li><img src="thumb-img4.jpg" class="thumb" data-image="img4.jpg"></li> 
       </ul> 
    </div> 
</section> 
</div>
～～～～～～～～
<script> 
'use strict';  
const thumbs = document.querySelectorAll('.thumb'); 
thumbs.forEach(function(item, index) { 
    item.onclick = function() { 
        document.getElementById('bigimg').src = this.dataset.image; //その取得したElementオブジェクトのsrc属性に代入する
    } 
}); 
</script>
```

* 先ず、divとliにそれぞれimgタグがある。liの方はそれぞれthumbというクラスがついており、これら全てをquerySelesctorAll()メソッドで集めてNodeListオブジェクトとして格納（querySelectorAll()メソッド参照）

★ここで、data-何でも属性について(html記法でdata-何とかと付けた値をjavascriptのdatasetで取得できる)

⇒本来の名前はカスタム属性といい、data-の後の名前は基本何でもよい。htmlタグのデータを埋め込める機能があり、ほぼ全てのhtmlタグに埋め込める。今回では、javascriptで読み取るために利用する。そして、このカスタム属性専用の機能はdatasetである。
>（JavaScriptにはdata属性の取得・追加・更新といった操作を簡単に実行することができる便利なプロパティが用意されています。
>これが「dataset」というプロパティになります。）
⇒取得した要素.dataset.の後ろは、data-後ろに付けた名前（data-imageだったらimageが入る）

### ビルドイン関数（スクリプトのどこからでも使用可能な関数で、グローバル・オブジェクトのメソッドとして参照されます）

①parseInt()メソッド：（ ）を小数点を切り捨て整数値にする、ただし、文字列の文章は整数にはできず、あくまで ’10’ このような文字列を予測して変換してくれる。  
⇒window.promptで入力された数値は文字列なので、integerに変えたいなら、この（ ）に結果を入れる。

```javascript
let answer = parseInt(window.prompt('1~5の数値を入れてね'));
```

②String()メソッド：（ ）の中をstringオブジェクトに変える

```javascript
String(counter[2]).padStart(2, '0')
```

⇒counter[2]の中の値がintegerであり、padStartはStringオブジェクトのメソッドなので変えないといけない

### this：イベントに設定するファンクション内で使える

[thisについて](https://pikawaka.com/javascript/this-1)

```javascript
const thumbs = document.querySelectorAll('.thumb'); 
thumbs.forEach(function(item, index) { 
    item.onclick = function() { 
        console.log(this.dataset.image); //その要素のdatasetということは、その要素自体を指している
    } 
});
```

⇒この場合、イベントが発生した要素、ここではonclickイベントが発生した、つまりクリックされた要素を指す。cosole.log()メソッドでどうやって参照したい値を表現するかという時に非常に便利！

### ★if文

⇒最初の（  ）内に条件。次のブラケットに処理内容

```javascript
if(window.confirm('よろしいですか？')) { 
  console.log('trueを返します'); 
} else { 
  console.log('falseを返します'); 
}
```

### ★while構文

⇒if文と同じ形式の（  ）で初めて条件を記述。条件がみたされるまで{  }の中身を繰り返す。

```javascript
let i = 1; 
while(i < 10) { 
   console.log(i + '枚') ;
   i += 1 ;
}
```

⇒while文は、条件に達しないとループしてしまうので、（ ）内の他にも部品が必要

①先にwhile文の**前に**変数の宣言（🔺注意🔺：ここをconstにしてしまうと増えていく数値の場合、定数だと変化しないのでエラーになる）  
⇒while文の中だったらconstのスコープが文の中になるので、constでも変更できる。つまり、while文の中のconst変数は、外から参照できない。{  }の中のconstやletは一周ごとに初期化されるので外から参照できない。

②数値をワンループごとに増やすコードを入れる。（繰り返しに使う時の変数は「i」が多いらしい）

### ★for~let~of構文

⇒for~ofの「~」の中が終了するまで繰り返す。

★ `for(let for内で使う変数の宣言 of 代入するもの）`：()の中にコンマは要らない

```javascript
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を食べる', '洗濯をする']; 
array.push('歯医者に行く'); 
for(let item of array) { 
   console.log(item); 
}
//配列要素にpushメソッドで値を追加、全アイテムをlogメソッドで出力
```

### for~let~in構文

⇒for~let~ofと違い、オブジェクトのプロパティを全て読み取ることだけを目的とした構文（連想配列の読み出しに使う）

```javascript
const book = {title: 'jsbook', price: '1000円', color: 'red', stock: 3}; 
book.title = 'rubybook'; 
for(let p in book) { 
   console.log(p + '=' + book[p]); 
}
```

⇒変数の宣言の所は、プロパティ名が入る（pの所）。そのプロパティ名を利用してbook[p]と打てば、１周ごとに取り出されるプロパティ名の中身が取れる。  
⇒重要な事は、連想配列の中身の取り出し方はbook.titleだったが、この構文の中では使えず、book['title']の形で取らないといけない

### function構文

⇒よく行う処理を１つにまとめた小さなミニプログラムであり、functionは外で呼び出さないと結果が出ない！

🔶重要🔶：returnが無いとエラーになる。つまり、ファンクションはリターンをセットにしてリターンを返す機能である。引数を外から代入した場合、その引数がファンクション内で使われていないとエラーになる。function自身に設定した引数は、function内でしか使えない。

```javascript
function total(price) { 
   const tax = 0.1; 
   return price + price * tax; 
} 
console.log(total(8000));
```

★funcitonの結果をhtmlに出す

```html
<p id="choice">ここに日時を表示します</p> 
~~~~~~~~
<script> 
  'use strict'; 
  function total(price) { 
    const tax = 0.1; 
    return price + price * tax; 
  } 
  document.getElementById('choice').textContent = total(8000) 
</script>
```

### javascriptの便利機能～

①テンプレート文字列（`${  }`）  
⇒バッククオートで囲んだ文字列をテンプレート文字列と呼ぶ。バッククオートで囲んだ所を文字列にする機能があり、それとは別に、文字列中に${ }を使って変数を埋め込むことが出来る。シングルコーテは ＋ を使えば結合できるが、いちいち次の文字列をシングルコーテで囲まなくて良い。

* 他にも、`${  }`の中にはfunctionのメソッドを入れることができる。

* 他にも、`${  }`の中で計算もできる（const  total  =  `大人二人：${1800  *  2}`;）

* バッククオート内は改行ができる。シングルコーテはできない。これはhtmlタグを含めた文字列を書くときに長くなり、インデント整理も必要なので重要
