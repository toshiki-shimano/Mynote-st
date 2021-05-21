# Minitestのやり方

```ruby
require "minitest/autorun"

class SampleTest < Minitest::Test
  def test_sample
    assert_equal "RUBY", "ruby".upcase
  end
end
```

①requireの行ではライブラリを読み込む  
②classにMinitest::testを継承（class名は自由でTestで終わらせる）  
🔶重要🔶：defはtest～の名前ではないといけない。Minitestではtest~で始まるメソッドを探して実行する  
③流れとしては、Minitestがtestと書かれているメソッドを探して、そのメソッド内の検証メソッドを実行するという流れ

## Minitestが提供するメソッド

①assert_equal
⇒assert_equal 期待する結果, テスト対象となる式と値

②assert
⇒assert a でaが真であればパスする

③refute
⇒refute a でaが偽であればパスする

## 実行すると

```html
Run options: --seed 50206

# Running:

F
<!-- 失敗のF-->
Failure:
SampleTest#test_sample [code.rb:5]:
Expected: "RUBY"
  Actual: "Ruby"
<!-- capitalizeメソッドをrubyに対して使った（先頭を大文字にする） -->

rails test code.rb:4



Finished in 0.002855s, 350.3240 runs/s, 350.3240 assertions/s.
<!-- 左から、テスト実行にかかった秒数、1秒間にじっこうできるであろうテストメソッドの件数、1秒間に実行できるであろう検証メソッドの件数 -->
1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
<!-- 左から、実行したテストメソッド件数、実行した検証メソッドの件数、検証に失敗したテストメソッドの件数、検証中にエラーが発生したテストメソッドの件数、skipメソッドにより実行をスキップされたテストメソッドの件数 -->
```

## 実際のテストファイル

```ruby
def fizz_buzz(inte)
    if inte % 15 == 0 && inte >= 15
        "Fizz Buzz"
    elsif inte % 5 == 0 && inte >= 5
        "Buzz"
    elsif inte % 3 == 0 && inte >= 3
        "Fizz"
    else
          inte.to_s
    end
end

require "minitest/autorun"

class FizzBuzzTest < Minitest::Test
  def test_fizz_buzz
    assert_equal "Fizz Buzz", fizz_buzz(15)
    assert_equal "Buzz", fizz_buzz(5)
    assert_equal "Fizz", fizz_buzz(3)
    assert_equal "2", fizz_buzz(2)
  end
end
```

🔶重要🔶これでテストは通るが、実際にはテスト実行コードとプログラムを分けてかんりすべきである。

⇒outruby/code.rb(ここにプログラム)
⇒readruby/test.rb(ここにテストコード)
※outrubyとreadrubyは同じディレクトリ

```ruby
# test.rbファイルでcode.rbをrequireする
require "minitest/autorun"
require_relative "../outruby/code.rb"

class FizzBuzzTest < Minitest::Test
  def test_fizz_buzz
    assert_equal "Fizz Buzz", fizz_buzz(15)
    assert_equal "Buzz", fizz_buzz(5)
    assert_equal "Fizz", fizz_buzz(3)
    assert_equal "2", fizz_buzz(2)
  end
end
```
