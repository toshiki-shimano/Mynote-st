# FizzBuzz

```ruby
def fizz_buzz(inte)
    if inte % 15 == 0 && inte >= 15
      puts  "Fizz Buzz"
    elsif inte % 5 == 0 && inte >= 5
      puts  "Buzz"
    elsif inte % 3 == 0 && inte >= 3
      puts "Fizz"
    else
      puts inte.to_s
    end
end

i = 1
while i < 16 do
    fizz_bug(i)
    i += 1
end
```
