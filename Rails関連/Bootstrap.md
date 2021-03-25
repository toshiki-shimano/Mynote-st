# Bootstrapの機能

## それぞれの機能

### form-groupとform-control

* 主にform_withといったformを作成するところで使うcssクラス。テキスト・パスワード・テキストボックスでは、入力部品となるグループに .form-groupを、入力部品の方に .form-control を指定する。

### navbarクラス

* navbarクラスを使うにはnavタグに`class="navbar"`と、.navbar-expand-{sm、md、lg、xl}と、カラースキームの指定が必要。さらに、ulタグにも`navbar-nav`を付けてレイアウトをそろえるためにclassをnav-itemクラスを必ず付けること

```html
<nav class="navbar navbar-expand-md navbar-light">
<div class="navbar-brand">Willnote</div>
      <ul class="navbar-nav ml-auto">
      ～～
         <li class="nav-item"><%= link_to "#{current_user.name}さん", edit_user_path(current_user), class: "nav-link" %></li>
```

⇒expand～が無いと、横並びにならない。lightが無いと文字が青く光ってしまう。（lightは灰色になる）
⇒navbarクラスで使えるbrandは文字を強調
⇒🔶重要🔶ulタグにもnavbar-navをつける。ブランド名と離したいなら、li要素をml-autoで左詰めにする。

### グリッドシステム

* グリッドシステム：rowクラスは、振り分け用。これを設定すると１２の中なら横並びになる。rowクラスの中にまたrowクラスを入れることも可能。colの中の要素はデフォルトでpadding:15があるので、そのcol自体をcssで指定してpadding:0にすれば隙間はなくなる。bootsrtapでpx-0にすればできる
