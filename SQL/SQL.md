# SQL基礎（まずここを押さえる）

* 前知識

1. 列（カラム）が縦のライン。行（row:要素）はカラムの各要素（中身）

## ★基本

◍テーブルからcolumn(カラム、列)を検索

```SQL
select 出金額 from 家計簿 
```

⇒家計簿がテーブル

◍全検索

```SQL
select * from 家計簿
```

⇒アスタリスクが全てを検索

◍条件検索

```SQL
select 日付, 費目, 出金額 from 家計簿
  where  出金額 < 3000
```

◍row（行）の挿入（テーブルに新たに要素を追加する）

```SQL
insert into 家計簿
  values ('2018-02-25', '居住費',  '3月の家賃',  0, 85000)
```

⇒区切りはダブルコーテーションではなくシングルじゃないとエラー。カラムごとの項目分要素が無いといけない。無いなら、nullを入れる。

◍rowの更新

```SQL
update  家計簿
set  出金額  =  90000
where  日付  =  '2018-02-25'
```

⇒WHEREは別に日付ではなくてもOK。選択した、カラムと要素が合っていれば、特定できる。

◍rowの削除

```SQL
delete from  家計簿
where  日付  =  '2018-02-05'
```

◍like演算子（ワイルドカードの事）とbetween演算子（andの事）

```SQL
select  *  from  家計簿
  where  メモ  like  '%１月%'

  where  出金額  100  and  1000 /*ちょうどの値でもtrueになる*/
```
  
⇒％：任意の０文字以上の文字列  
⇒＿：任意の文字１文字  
⇒andは100~1000のこと  

* ～マッチング例～

★`％1月`は1月で終わる要素を検索。
★`1月％`は1月で始まる要素を検索。

◍in/not  in演算子

```SQL
select * from 家計簿
  where 費目 in ('食費',  '交際費')
/*費目カラムで食費と交際費に合う要素を取得*/
  where 費目 not in ('食費', '交際費') 
```

⇒値が（）内に列挙した複数の値のいずれかに合致するか判定する

◍anyとall演算子(副問い合わせでしか使えない時がある)

```SQL
select * from 家計簿
  where 出金額 < any (1000, 2000, 3000)
/* 出金額が２５００で、＜なら、２５００は３０００より小さいので式はtrue(どれか一つでも条件を満たせば良い)*/
  where 出金額 < all (1000, 2000, 3000)
/* 出金額が１０００で、＜なら、１０００は（）の１０００より小さないのでfalse*（全ての条件を満たさないといけない）/
```

⇒必ず＜＞比較演算子を使う。

◍distinct：select文に付加すると、結果表の中で重複を取り除く

```SQL
select distinct カラム from テーブル名
```

◍order by：select文の最後に記述すると、指定した列の値を基準として検索結果を並べ替えて取得  
⇒昇順はasc（量が少ない順）。降順はdesc（量が多い順）

```SQL
select * from 家計簿
  order by 入金額 desc, 出金額 desc
```

◍offset-fetchとlimit：並べ替えた結果の一部だけ表示したい
⇒offset句：先頭から除外する要素を決める。つまり、要素が５個あり、それを降順で並べて、一位と二位を除外した三位を上から順に出す、つまり三番目が一番上になる。`offset  3  rows`  
⇒fetch句：いくつ要素を出したいかを指定する（5個の要素の内、3つだけなど）。例えば、offsetで除外されてデータが３つしかないのに、`fetch next 5 rows only`と5個のデータが出るようにしても3つしか出ない。
⇒limit：select fromの後やorder byの後に単純につけると表示数を制限できる。

```SQL
select 費目, 出金額 from 家計簿
 order by 出金額 desc
 offset 2 rows
 fetch next 2 rows only

select 費目, 出金額 from 家計簿
 limit 3
```

◍和集合（union）：二つのselect文をつないで、足し合わせた結果を表示する

```SQL
select 費目, 入金額, 出金額 from 家計簿
union
select 費目, 入金額, 出金額 from 家計簿アーカイブ
 order by 2, 3, 1 
```

◍差集合（except）：select文から重複している分を引いて残す。select文の順番に注意！ベースのテーブルを決めて、そこから引くテーブルを決める。引く方を先に記述してしまうと結果がおかしくなる。

```SQL
select 費目 from 家計簿
except
select 費目 from 家計簿アーカイブ
```

◍積集合（intersect）：重複した部分を表示する

```SQL
select 費目 from 家計簿
intersect
select 費目 from 家計簿アーカイブ
```
