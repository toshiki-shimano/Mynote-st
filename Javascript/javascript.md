# Javascriptについて

## 前知識

* bracketsがjavascriptに対応しているみたい。ライブプレビューの何も書いてないのに出るfabiconエラーは、下記のコードをheadに入れる  
⇒`<link rel="icon" href="data:;base64,iVBORwOKGO=" />` [参考](https://python5.com/q/nfckbznk)
⇒また、jsの外部ファイルは読み込めないみたい、html本体のファイルに書き込む。

★参照とは：値を読み取ったり、変数の場合は書き換えたりすること

⓪if文：条件分岐でブラケット中のtrueとそれ以外の内容を実行する
```
if(window.confirm('よろしいですか？')) { 
  console.log('trueを返します'); 
} else { 
  console.log('falseを返します'); 
}
```
◍if ( ～)  {  ～ }：条件と実行部分。（）の部分がtrueならばtrueの内容｛｝を返す

①while構文：if文と同じ形式の（　）で初めて、条件がみたされるまで{　  }の中身を繰り返す。
```
let i = 1; 
while(i < 10) { 
   console.log(i + '枚') ;
   i += 1 ;
}
```
◍先ずwhile文は、条件しか定めないので、条件を終わらせる条件を他に２つ書かなくてはいけない
⇒先にwhile文前に変数の宣言（注意：ここをconstにしてしまうと増えていく数値の場合、定数だと変化しないのでエラーになる）
⇒そして、定めた変数は（　）の条件や｛　｝で使われ、そこに値が入っていく。
⇒whileの外にあるconstを使うとwhile文の中で変更できないが、while文の中だったらconstのscopeが文の中になるので、constでも変更できる。つまり、while文の中のconst変数は、外から参照できない。｛　｝
のconstやletは繰り返すごとに消去されるので外から参照できない。
⇒上記なら、数値が増えていかないとループするので、数値をワンループごとに増やすコードを入れる。
⇒繰り返しに使う時の変数は「  i  」 が多いらしい

③for～of構文：～の中を終了するまで繰り返す
⇒for（for内で使う変数の宣言　of　代入するもの）#中にコンマは要らない
```
let array = ['牛乳を買う', 'コンビニに行く', 'ご飯を食べる', '洗濯をする']; 
array.push('歯医者に行く'); 
for(let item of array) { 
   console.log(item); 
}
```
◍配列要素にpushメソッドで値を追加、全アイテムをlogメソッドで出力

④for～in構文：for~ofと違い、オブジェクトのプロパティを全て読み取ることだけを目的とした構文（連想配列の読み出しに使う）
```
const book = {title: 'jsbook', price: '1000円', color: 'red', stock: 3}; 
book.title = 'rubybook'; 
for(let p in book) { 
   console.log(p + '=' + book[p]); 
}
```
◍変数の宣言の所は、プロパティ名が入る（ｐの所）。そのプロパティ名を利用してbook[p]と打てば、１周ごとに取り出されるプロパティ名の中身が取れる。
◍重要な事は、連想配列の中身の取り出し方はbook.titleだったが、この構文では使えずbook[ ' title ' ]で取らないといけない

㊿function構文：よく行う処理を１つにまとめた小さなミニプログラム
⇒returnが無いとエラーになる。つまり、ファンクションはリターンをセットにしてリターンを返す機能である
⇒functionは外で呼び出さないと結果が出ない！
```
function total(price) { 
   const tax = 0.1; 
   return price + price * tax; 
} 
console.log(total(8000));
```
◍引数を外から代入した場合、その引数がファンクション内で使われていないとエラーになる。function自身に設定した引数は、function内でしか使えない
==funcitonの結果をhtmlに出す==
```
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
◍ファンクションのリターンをElementオブジェクトのtextContentプロパティに入れるとhtml要素のコンテンツが変わる。

～javascriptの便利機能～
①テンプレート文字列（`    ${        }     `）
◍バッククオートで囲んだ文字列をテンプレート文字列と呼ぶ。バッククオートで囲んだ所を文字列にする機能があり、それとは別に、文字列中に${   }を使って変数を埋め込むことが出来る。シングルコーテは  ＋  を使えば結合できるが、いちいち次の文字列をシングルコーテで囲まなくて良い。
◍他にも、${  }の中にはfunctionのメソッドを入れることができる。
◍他にも、${  }の中で計算もできる（const  total  =  `大人二人：${1800  *  2}`;）
⇒バッククオートで文字列を作成して、さらにその中で計算をしている
◍バッククオート内は改行ができる。シングルコーテはできない。これは、htmlタグを含めた文字列を書くときに長くなり、インデント整理も必要なので重要