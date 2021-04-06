# ドリルの答え

★p132の４－１－５

```sql
select 分類, 商品名, サイズ, 単価 from 注文履歴
 where 分類 = '1' 
 union
 select 分類, 商品名, null, 単価 from 注文履歴
 where 分類 = '2' 
 union
 select 分類, 商品名, null, 単価 from 注文履歴
 where 分類 = '3'
 order by 1, 2
```

★P165の５－１－a

```sql
update 試験結果
set 午後1 = 80 * 4 - 86 - 68 - 91
where 受験者id = 'SW1046'
```