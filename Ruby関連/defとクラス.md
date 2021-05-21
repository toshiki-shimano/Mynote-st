# defとクラス

## def

### 前知識

★defの引数に「＊」を付けると可変長引数にできる

```ruby
def greeting(*name)
  "#{name.join('と')}、こんにちは！"
end
print greeting("田中さん", "鈴木さん", "佐藤さん")
#田中さんと鈴木さんと佐藤さん、こんにちは！
```
