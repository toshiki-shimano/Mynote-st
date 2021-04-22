# if文とcase文

## if文

★if文の結果は戻り値として変えるので、その返り値を変数に代入することも可能

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
