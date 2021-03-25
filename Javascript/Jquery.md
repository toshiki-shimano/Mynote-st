# Jquery関連

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
⇒attr()メソッド：jqrueryオブジェクトのHTML要素の属性を取得したり設定することができる  
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
