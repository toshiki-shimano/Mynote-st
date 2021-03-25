# Cssのまとめ

上 | 左右 | 下  
margin: 1em auto 2em;

上 | 右 | 下 | 左
margin: 2px 1em 0 auto;

①transform
⇒与えられた要素を回転、拡大縮小、傾斜、移動させる。
⇒translate3d(x軸方向への移動量（左右）、y軸方向への移動量（上下）、z軸方向への移動量（奥手前）)

```css
.show {
    transform: translate3d(-270px, 0, 0);
}
```

②ulの黒点消し
⇒ulのliタグには最初からmarginとpaddingがついているのでそれを0にする。そして、黒点のデザインを無しにする

```css
.postPage nav ul {
    margin: 0;
    padding: 0;
    list-style-type: none;
}
```

③入力フォームや出力データの真ん中に寄せて、幅を決める

```css
.noteEditPage .space {
    width: 50%;
    margin: 0 auto;
}
```

④flex

```html
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
```

```css
.archivemain {
    display: flex;
    justify-content: space-around;
}
```

⇒flexは、親要素（archivemain）にかけると子要素（figure）が横並びになる  
⇒flexプロパティを追加した後に、flex-direction: 値;で縦にしたり、並び順を逆にしたり、、  
⇒justfy-contentというプロパティも追加でき、等分配置が出来たりする  
⇒display: flex;の横担当は、justify-content、縦担当はalign-items  
