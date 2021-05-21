# if文とcase文と条件演算子

## if文

★if文の結果は戻り値として変えるので、その返り値を変数に代入することも可能
★unless文はif文の反対だが、elsifみたいなことは出来ない

```ruby
country = "japan"
greeting = 
 if country == "japan"
   "こんにちは"
 elsif country == "us"
   "hello"
 else
   "???"
 end

puts greeting
#結果は、こんにちは
```

### ifの修飾子

★rubyのif文は、修飾子として文の後ろに置ける(ifの処理を前に持ってくることができる)  
⇒endがいらない

```ruby
point = 7
day = 1
point *= 5 if day == 1
puts point
#結果は３５
```

### casa文

★if文と違い、条件を簡単に記述できる

```ruby
country = "italy"
 test = case country
        when "japan"
           "こんにちは"
        when "italy"
          "ciao"
        when "us"
          "hello"
        else 
          "???"
        end
puts test
```

### 条件演算子

★式 ？ 真だった場合の処理 : 偽だった場合の処理

```ruby
n = 11
message = n < 10 ? "10より小さいです" : "10以上です"
puts message
```
