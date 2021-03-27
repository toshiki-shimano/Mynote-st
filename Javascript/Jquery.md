# Jquery関連

## 前知識

* jQuery(document).readyや、 $(function()の記述では、ページの読み込みを起点として発火します
⇒つまり、画面の一部が切り替わった場合はイベントが発生しないことになります。
⇒そこで、Turbolinksを無効化させる、Ajax後にも発火するように設定する、ということで対処していきます。

●https://wp-p.info/tpl_rep.php?cat=js-biginner&fl=r13(わかりやすい)
●https://www.sejuku.net/blog/27019（getElementById、innerHTML、valueについて簡単な説明）

★コードの基本
　console.log(number);
（オブジェクト、メソッド、パラメーター、文章の終わりセミコロン）
★オブジェクト（consoleやdocumentやwindow）
◍ブラウザなどに見える機能それぞれを指す（window全体、コンソール、使われているhtml要素、url欄のlocationなど）
◍オブジェクトが持っているメソッドは決まっている。windowオブジェクトは、alertメソッドを使えるが、consoleオブジェクトのlogメソッドは使えない。
◍全てのオブジェクトは、メソッド以外にプロパティというのものを持っている
⇒〇〇オブジェクトの□□は△△である
⇒〇〇オブジェクトの□□を△△にする
などの□□がプロパティで△△がプロパティ値
★メソッド（オブジェクトに命令を出すモノ）
◍メソッドの後には必ず（）を付ける！。
★プロパティ（そのオブジェクトの状態を表すモノ（例えば、locationオブジェクトはブラウザのURLを担っているが、その状態を指し示すなら、hrefプロパティというのを指定して、そこに新しいURLを入れれば、URLが変わる））
◍textContent：要素のコンテンツを表すプロパティ

⓪consoleオブジェクト
⇒log()メソッド：コンソールでプログラムが正しく表示されるか見る
```
console.log('こんにちは')
console.log(number)
```

①windowオブジェクト
⇒alert()メソッド：ブラウザが読み込まれたら上にダイアログボックスを表示する
```
window.alert('変更')
＃ページを読み込むと上に表示される
```

⇒confirmメソッド：ダイアログボックスに「はい」と「いいえ」がある形式
```
window.confirm('いいですか？')
```
◍alertメソッドと違いリターン（実行結果）を返してくる。（trueかfalseを返す）
◍if文との説明がわかりやすい

⇒prompt()メソッド：ダイアログにテキストフィールドを作り、その入力された値を保存する。このメソッドは、OKをクリックした時にリターンを返し、キャンセルを押したときは何も返さない
```
const respond = window.prompt('helpを見ますか？') 
if(respond === 'yes') { 　　　　　　　　　　　　　　　　　＃yesをシングルで囲む
  console.log('yesを返します'); 
} else if(respond === 'no') { 
  console.log('falseを返します');
} else {
  console.log('それ以外を返します'); 
}
```
◍入力された値が文字列の時は、ifの条件の所をシングルで囲まないと認識されない

②documentオブジェクト
⇒getElementByIdメソッド()：html要素の指定id属性を丸ごと取得
◍さらこれで取得された要素をjavascriptではElementオブジェクトとして扱い、このオブジェクトも独自のメソッドとプロパティを持つ。textContentはElementオブジェクトのプロパティである。

⇒textContentプロパティ：これを付けると、＝で取得したhtml要素のコンテンツ部分（タグの中身）を変えることができる。代入しないと、読み取る
```
<p id="choice">ここに日時を表示します</p>
<script> 
      'use strict';       
      document.getElementById('choice').textContent = '変更'; #書き換える
      document.getElementById('choice').textContent; #書き換えるのではなく読み取る

</script>
```

```
<table> 
   <tr> 
     <td id="title"></td>
～～～～～～
let book = {title: 'jsbook', price: '1000円', stock: 3}; 
document.getElementById('title').textContent = book.title;
```
◍textContentプロパティは、要素のコンテンツを書き換えたりできるので、<td>に何もなくても、連想配列のデータ値を入れることができる

⇒querySelector()メソッド：（　）内に書かれたセレクタにマッチする要素を取得する。ここでいうセレクタとは、CSSで最初に書く、#notePageとか、.pagecontentとか、body、htmlといったCSSセレクタを指す。つまり、形状CSSのセレクタを指定しているみたいな感じ。
querySelector('option[value="index.html"]')のこの場合の[~~]の中は、CSSでは属性セレクタと呼ばれる。
◍注意は、optionというセレクタが複数あった場合には最初にマッチしたものしか読み取らない

⇒querySelectorAll()メソッド：（　）内で指定されたCSSセレクタにマッチする要素を全て取得
◍このメソッドは取得した要素は配列みたいに格納されるが配列オブジェクトではない。取得された要素は、NodeListオブジェクトとして生成されるので、配列オブジェクトのメソッドは使えない。forEach()メソッドは一応使えるみたい

⇒createElement()メソッド：（　）内のタグ名を持つ要素を生成して。メモリに保存するメソッド


③Elementオブジェクト
⇒textContentプロパティ：＝で取得したhtml要素のコンテンツ部分（タグの中身）を変えることができる。代入しないと、読み取る
```
document.getElementById('choice').textContent = '変更'; #書き換える
```

⇒insertAdjacentHTML()メソッド：所得した「要素」の前か、その要素の中に（子要素として）別の要素を入れることができる。
（insertAdjacentHTML（'挿入する場所' ,  タグが付いた状態で整理されたデータ））
```
<h1>やることリスト</h1> 
<ul id="list"> 
＃この中にbeforeendで要素を入れる（親要素である<ul>の中に<li>を含めた要素を入れる）
</ul>　＃終了タグ　 
<script> 
'use strict'; 
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を買う', '掃除をする']; 
for(let item of array) { 　
    const listpro = `<li>${item}</li>`;  ＃ここでちゃんとタグを付けておかないと反映されない
    document.getElementById('list').insertAdjacentHTML('beforeend', listpro); 
} 
</script
```
◍'beforeend'は、取得した要素の子要素として挿入。（取得した要素の終了タグの前に挿入。ここで言う</ul>の前）
◍for～ofで一つ一つのデータに<li>タグを付けていく

⇒removeChild()メソッド：既にあるHTML要素の子要素か孫要素を削除する。


⇒各イベントプロパティ（ページの下参照）
◍onsubmitイベントプロパティ
◍onchangeイベントプロパティ
◍onclickイベントプロパティ

④Mathオブジェクト（ｐ１８０）
⇒random()メソッド：何も書かなければ、０～１のランダムの数値を生み出す、
```
const attack = Math.floor(Math.random() * 30) + 1
```
◍上記のランダムの範囲は１～３０。後ろの +  1が無ければ、範囲は０～３０。 *  30が無いと範囲は０～１になる。

⇒floor()メソッド：(   )内の数値の小数点以下を切り捨てる
⇒PIプロパティ：円周率を表示する
```
<p>円周率は<span id="pi"></span></p> 　　　　　　　　　　　　　　　　　　　　　　　※3.141592653589793
<p>普通に切り捨てると<span id="cutpi"></span></p> 　　　　　　　　　　　　　　　　 ※3
<p>第二小数点で切り捨てると<span id="secondcutpi"></span></p>                    ※3.14
<script> 
'use strict'; 
document.getElementById('pi').textContent = Math.PI 
document.getElementById('cutpi').textContent = Math.floor(Math.PI) 
       
function point(num, digit) { 
  　const pinum = 10 ** digit; 
    return Math.floor(num * pinum) / pinum; 
} 
document.getElementById('secondcutpi').textContent = point(Math.PI, 2); 
</script>
```
◍もし円周率を第二小数点で切りたい時、その機能はないので、第2小数点なら１００を掛けて、その状態で小数点以下を切り捨て、
その後１００で割ればよい
⇒digitは第何の小数点で切りたいか。第３なら、１０の3乗で１０００で掛ける。円周率は３１４１.５９～なるので、小数点以下を切り捨て、３１４１を１０００で割れば３．１４１になる









⑤配列オブジェクト：配列が入ったデータそのものや変数を指す（constは全体を変えることはできないが、一部を変えることはできる）
⇒push()メソッド：配列データの最後にデータを追加
⇒unshift()メソッド：配列データに最初にデータを追加
⇒pop()メソッド：配列データの最後のデータを削除
⇒shift()メソッド：配列データの最初のデータを削除
```
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を食べる', '洗濯をする']; 
array.push('歯医者に行く');
```

⇒forEach(function(item, index) {  処理内容 }); メソッド：配列の各項目を繰り返し処理する。特徴的なのは、functionと引数がセットになっているところ。｛　｝で書かれた処理が配列の各項目に全て実行される。itemに内容が、indexにはインデックスが入る。

⇒lengthプロパティ：配列の項目数を表す

⇒join()メソッド：配列の要素を繋げて文字列に変換することができる便利な機能。配列データに「join」メソッドを繋げるだけで、配列の各要素がすべて連結されて「文字列」として生成されるようになっています。
```
var array = ['2017', '08', '03']; 
var result = array.join('-');   
console.log( result );
⇒結果：２０１７－０８－０３
```
◍配列の要素をそのまま連結したい場合は、引数に「空文字」を指定すればよい
```
var array = ['今日の天気は', '雨', 'でした']; 
var result = array.join('');
console.log( result );
⇒今日の天気は雨でした
```


⑥連想配列オブジェクト＝javascriptではただのオブジェクトを呼んでいる（for~ofでは全て読み取れない）
```
let book = {title: 'jsbook', price: '1000円', color: 'red', stock: 3}; 
book.title = 'rubybook'
console.log(book.title);
```
◍インデックスで呼ぶ時には、ドットを付けて呼ぶ。これは、この作られたbookオブジェクトの（連想配列オブジェクトの）プロパティだから。
他の呼び方として、console.log(title['price'])という出し方もできる
◍上記を利用して代入の仕方は、ドットでプロパティを呼び、代入する。（book.title = 'rubybook'）
◍title:  'jsbooki'  でtitleがプロパティ名、'jsbook'がデータ値、全体でプロパティと呼び、データ値にfunctionを入れることが出来る 
◍配列オブジェクトと違い、取り出される順番に順序がないらしい。

⑦Dateオブジェクト（最初に変数に入れて初期化しないといけない。newで新しいインスタンスすることによって初期化している）
★現在の日時を取得する
★過去や未来の日時を取得する
★時間の計算
◍getFullYear()
⇒年を取得
◍getMonth()
⇒月を取得
◍getDate()
⇒日を取得
◍getHours()
⇒時間を取得
◍getMinutes()
⇒分を取得
◍getSeconds()
⇒秒を取得
◍getTime()
⇒1970年1月1日０秒からの時間をミリ秒で取得


⇒const  date  =  new  Date()：(  )の中に何も入れない状態で作ると現在の時間が入る　
```
const hour = new Date().getHours() 
const minute = new Date().getMinutes() 
console.log(`${hour}時：${minute}分`)
```
◍new Date()で得られるのは、現在の時間で今の時間表記に単位が直してある！つまり、時間を引いたり足したりするには、単位の一番小さいミリ秒に直して全体を引いてからもう一度最初の単位に直す必要がある。なので、、⇩（ｐ１８３も参照）
⇒getTime()：1970年1月1日0秒からの今の時間をミリ秒で取得する。セッティングした時間もミリ秒にできるので、それらを計算することが出来る。
```
function countdown(due) { 
    const now = new Date(); 
    const rest = due.getTime() - now.getTime();　＃１６０１４７７９９９０００（未来）－１６０１４４５６０００００（現在）
　　～～～～～～～
```
ミリ秒を各単位に直すとなぜか小数点が出てくるので、必要な単位まで割り算したら、一度小数点を切り整数にする。それから、余りをだす％で割ってあげる。一度整数に直すのは、あまりがきちんと出るようにするため！
```
function countdown(due) { 
    const current = new Date(); 
    const rest = due.getTime() - current.getTime(); 
    const sec = Math.floor(rest / 1000) % 60; 　※ミリ秒を秒まで引き上げて、一度整数に直し、６０秒単位で割った余りが秒：ここでは５９
    const min = Math.floor(rest / 1000 / 60) % 60; 　　※秒に引き上げたら、単位もう一つ上に上げるので、分の単位６０でさらに割る。
    const hours = Math.floor(rest / 1000 / 60 / 60) % 24; 
    const days = Math.floor(rest / 1000 / 60 / 60 / 24); 
    const count = [days, hours, min, sec]; 
    return count; 
}
```
◍後に引数の中のファンクションを1秒ごとに実行するというsetTimeout()というメソッドがある
⇒setTimeout（ファンクション、待ち時間（何秒ごとに実行するかという数値））
⇒このメソッドの待ち時間はミリ秒単位なので１０００と打つと１秒ごとにという事になる。
⇒ここでのファンクションには（）を付けてはいけない！理由は、ｐ１９２

⑧Stringオブジェクト：シングルやバッククオートで囲まれた文字列
⇒padStart()メソッド：（　）の中は、（そろえる文字数、埋め合わせる用の文字　）

⑨locationオブジェクト：windowオブジェクトと同じくブラウザに最初から組み込まれているオブジェクトであり、URLを調べたり、閲覧履歴を管理したりする機能がある
⇒hrefプロパティ：今表示しているURLを書き換えて（location.href   =    新しいURL）、その先に移動する

🔶各イベントプロパティ
◍イベントに代入するファンクションにはメソッド名はつけない。また、実行部分でreturnを使わない！
◍input要素の入力内容をjavascriptで読み取るときは、inputタグのname属性から読み取る
（name="word"　たろう　と入力されたら、wordを参照して「たろう」を読み取る）
（formの中のselectタグにnameを仕込む時もある）
◍入力した内容を読み取るには、
（Elementオブジェクト.読み取りたいformの部品のname属性.value）
で、valueプロパティで値を取得する
◍要素にイベントが発生して、そのイベントプロパティに続くfunctionにeventという引数を置くと、funcitionにevetオブジェクトが渡されるので、そのオブジェクトのメソッドを使うのが可能になる。この引数に当たる（）の中の名前は好きな名前で大丈夫。つまり、わざわざ（event）にしなくて良い。引数に置いた名前がeventオブジェクトになる

①onsubmitイベントプロパティ：formタグのインプットタグのsubmitが押された瞬間に（ページ移動する前に）発動する。
```
<form action="#" method="#" id="datasearch"> 
   <input type="text" name="word"> 
   <input type="submit" value="検索"> 
</form> 
<p id="output"></p> 
～～～～～～～～～～～
<script> 
'use strict'; 
document.getElementById('datasearch').onsubmit = function() { 
    const search = document.getElementById('datasearch').word.value; 
    document.getElementById('output').textContent = `${search}を検索中`; 
} 
</script>
```
◍Elementオブジェクト.onsubmit  =  function( )  {  実行したいこと  }
（functionは基本メソッド名なし、引数無し）
◍先ず、form全体の要素を取得した後に、そのElementオブジェクトにonsubmitイベントを取り付ける。その実行部分で、form要素の中の絞ってさらにその中のword属性を読む！このままだと、ただの変数なので、wordの値を取得するためにvalueプロパティを扱う。なので基本、入力された値を取得するには、valueはセットで使うと考える。その入力された内容を変数に格納して、outputのidを持つ要素のコンテンツにtextContentで入れる。
◍ここで最後に、functionの引数にeventと書いて、次に　event.preventDefault();　を置くと、送信した時にそのページに移るという機能が動かないのでそのまま検索中というページで止まる。
アロー関数ならfunctionを省略してアローを付けるだけ
```
document.getElementById('datasearch').onsubmit = (event) => { 
   　　event.preventDefault();
```

②onchangeイベントプロパティ：formに入力された内容が変わった時に発生する。テキストフィールドなら入力内容が変わった時、プルダウンメニューなら選択項目が変わった時に発生する。
```
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
'use strict'; 
const lang = document.querySelector('html').lang; 
#下記のは、ぺージに移動したときにその選択肢が選択済みになるようにするための処理
if(lang === 'ja') { 
    document.querySelector('option[value="index.html"]').selected = true; 
} else if(lang === 'en') { 
    document.querySelector('option[value="index-en.html"]').selected = true; 
} else if(lang === 'zh') { 
    document.querySelector('option[value="index-zh.html"]').selected = true; 
} 
document.getElementById('form').select.onchange = function() { 　　＃A
    location.href = document.getElementById('form').select.value; 
}
```
◍プルダウンメニューが切り替わった時にそのURLに飛ぶようにする。つまり、最初にページを開いたときはまだプルダウンメニューは切り替わってないのでイベントは読み込まれない！だから、最初にlang="ja"のページを開いたら、if文では、lang  === jaなので日本語の選択肢のselectedがtrueになる。
★このプルダウンメニューでは、ユーザーが選択肢を変えるとイベントが発生してそのURLには飛ぶ。日本語ページから英語ページに飛んだとして、、、もし、英語にselectedがされておらず、選択肢が日本語のままなら、英語のページで日本語を選んでも選択肢が変わらないので、イベントが発生しなくなり、ページ移動できなくなる。したがってその後戻れるようにするには、英語ページに飛んだ時に、英語の選択肢にselectedがtrueになっている必要がある。（P208）
⇒先ず#Aでは、form部品の中のselectorをnameとして絞り、その内容が変わったら、formのselectのvalueのurlを新しいurlとしてhrefプロパティに入れる。
⇒何かをきっかけに分岐を使いたいが、そこでhtmlタグのlangに目を付ける。ここの要素を読み取って内容で分岐させる。ただここには、idが無いので、タグ自体を選択して読み取るquerySelector()メソッドを使い読み取る。そこで用意していた３つのhtmlファイルの内、表示したファイルのhtmlタグがjaなら、そのoptionのvalueを読み取り、選択済みにするためにtrueを入れる（selected = true）

③onclickイベントプロパティ：取得された要素がクリックされた時にイベント発生（主に<button>タグの時や画像のクリックした時、スマートフォンでタッチをした時にも発生）
```
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
        document.getElementById('bigimg').src = this.dataset.image; 　　＃その取得したElementオブジェクトのsrc属性に代入する
    } 
}); 
</script>
```
◍先ず、divとliにそれぞれimgタグがある。liの方はそれぞれthumbというクラスがついており、これら全てをquerySelesctorAll()メソッドで集めてNodeListオブジェクトとして格納（querySelectorAll()メソッド参照）
★ここで、data-何でも属性について：本来の名前はカスタム属性といい、dataーの後の名前は基本何でもよい。htmlタグのデータを埋め込める機能があり、ほぼ全てのhtmlタグに埋め込める。今回では、javascriptで読み取るために利用する。そして、このカスタム属性専用の機能はdatasetである。
（JavaScriptにはdata属性の取得・追加・更新といった操作を簡単に実行することができる便利なプロパティが用意されています。「dataset」というプロパティになります。）
⇒取得した要素.dataset.dataー後ろに付けた名前（data-imageだったらimageが入る）




🔶ビルドイン関数（スクリプトのどこからでも使用可能な関数で、グローバル・オブジェクトのメソッドとして参照されます）
①parseInt()メソッド：（　）を小数点を切り捨て整数値にする、ただし、文字列の文章は整数にはできず、あくまで ’10’ このような文字列を予測して変換してくれる。
◍window.promptで入力された数値は文字列なので、integerに変えたいなら、この（　）に結果を入れる。
```
let answer = parseInt(window.prompt('1~5の数値を入れてね'));
```
②String()メソッド：（     ）の中をstringオブジェクトに変える
```
String(counter[2]).padStart(2, '0')
```
◍counter[2]という変数がintegerであり、padStartはStringオブジェクトのメソッドなので変えないといけない



🔶this：イベントに設定するファンクション内で使える
https://pikawaka.com/javascript/this-1（thisについて）
```
const thumbs = document.querySelectorAll('.thumb'); 
thumbs.forEach(function(item, index) { 
    item.onclick = function() { 
        console.log(this.dataset.image); 　　＃その要素のdatasetということは、その要素自体を指している
    } 
});
```
◍この場合、イベントが発生した要素、ここではonclickイベントが発生した、つまりクリックされた要素を指す

```
<body>
    <p id="test">初めてのJavaScript勉強中だよ！</p>
    <script>
      var elem = document.getElementById("test");
      elem.innerHTML = "<span style='color: blue;'>span要素に変更したよ！</span>";
    </script>
    
  </body>
```
⇒htmlタグを含めた要素を丸々採取するには、documentというオブジェを用意する。この場合、空のdocumentにgetElementByIdメソッドを使って、上のpタグ全て採取して、elemという変数に入れる。
⇒innerHTMLというプロパティを使用すれば、要素の中身を変更する事が出来ます

- [ ] getElementById(任意のHTMLタグで指定したIDにマッチするドキュメント要素を取得するメソッド)
```
<body>
 <p id="myid">Hello world!</p>
 <script>
  console.log(document.getElementById("myid").textContent);
 </script>
</body>
```
⇒ここでは Hello world!だけが出る。textContentメソッドで中身だけの出力に絞っている。これが無いとpタグまで全て出る。
- [ ] value
```
<form> 
    <h1>入力フォーム</h1> 
    <h2>電話番号を入力してください</h2> 
    <input id="phoneNumberText" placeholder="電話番号" type="tel"> 
    <p id="warningMessage"></p> 
    <div class="button-wrapper"> 
      <button class="cancel">キャンセル</button> 
      <button class="submit">送信</button> 
    </div> 
  </form>
--------------以下ジャバスクリプトファイル

/** 電話番号の入力欄 */
const phoneNumberText = document.querySelector('#phoneNumberText');
/** 警告メッセージ */
const warningMessage = document.querySelector('#warningMessage');
// 文字が入力される度に、内容のチェックを行う
phoneNumberText.addEventListener('keyup', () => {
  // 入力された電話番号
  const phoneNumber = phoneNumberText.value;
  // 電話番号に「-」が含まれている場合は、''（空文字）に置き換える
  const trimmedPhoneNumber = phoneNumber.replace(/-/g, ''); // 09012345678
  // 0から始まる、10桁か11桁の数字かどうかをチェック
  if (/^[0][0-9]{9,10}$/.test(trimmedPhoneNumber) === false) {
    warningMessage.innerText = '電話番号を正しく入力してください';
  } else {
    warningMessage.innerText = '';
  }
});
```
⇒inputタグで作られた入力欄に入力した数値や文字をvalueを使って取り出せるみたい。const phoneNumberという変数にいれた後、phoneNumber.valueというので数値をとっている

* $.cookie()メソッド
⇒[cookieオブジェクトの取得の仕方](https://www.sejuku.net/blog/54153)

* prependTo()メソッド
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

* attr()メソッド
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

* append()メソッド
⇒指定した子要素の最後にテキスト文字やHTML要素を追加することができるメソッド
⇒下記のコードは、クリックイベントがないのでそのまま画面に追加表示される

```javascript
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
