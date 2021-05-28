class User
  def hello 
      "hello"
  end
end
user = User.new
p user::hello

# class Second
#     def greeting
#         "hello"
#     end
# end

# module Time_model
#     class Second
#         def bye
#             "See you"
#         end
#         @gree = ::Second.new
        
#         def greeting_old
#             @gree.greeting
#         end
#     end
# end

# time_model = Time_model::Second.new
# p time_model.greeting_old










# hash = {"apple" => 100, "melon" => 300}
# hash.each do |key, value|
#     key.freeze
#     value.freeze
# end
# p hash.freeze



# require "minitest/autorun"
# require_relative "../outruby/coderuby.rb"

# class DeepFreezeTest < Minitest::Test

#     def test_deep_array_freeze
#         # まず、配列の値は正しいか？
#         assert_equal ["Japan", "Us", "India"], Team::COUNTRIES
#         #Teamクラスの配列の外側はフリーズしているか？
#         assert Team::COUNTRIES.frozen?
#         #中身がフリーズしているか？
#         assert Team::COUNTRIES.all? {|country| country.frozen?}
#     end

#     def test_deep_hash_freeze
#         assert_equal ({"Japan" => "yen", "Us" => "dollar", "India" => "rupee"}), Bank::CURRENCIES
#         assert Bank::CURRENCIES.frozen?
#         assert Bank::CURRENCIES.all? {|key, value| key.frozen? && value.frozen?}
#     end
# end



# require "minitest/autorun"
# require_relative "../outruby/code.rb"

# class TestHas < Minitest::Test
#   def test_hash
#     old_syntax = <<~TEXT
#     {
#       :name => 'Alice',
#       :age=>20,
#       :gender  =>  :female
#     }
#     TEXT
#     expected = <<~TEXT
#     {
#       name: 'Alice',
#       age: 20,
#       gender: :female
#     }
#     TEXT
#     assert_equal expected, convert_hash(old_syntax)
#   end
# end




# require "minitest/autorun"
# require_relative "../outruby/code.rb"

# class RgbTest < Minitest::Test
#   def test_to_hex
#     assert_equal "#000000", to_hex(0, 0, 0)
#     assert_equal "#ffffff", to_hex(255, 255, 255)
    
#   end

#   def test_to_ints
#     assert_equal [0, 0, 0], to_ints("#000000")
#     assert_equal [255, 255, 255], to_ints("#ffffff")
#   end
# end




# # require "minitest/autorun"
# # require_relative "../outruby/code.rb"

# # class FizzBuzzTest < Minitest::Test
# #   def test_fizz_buzz
# #     assert_equal "Fizz Buzz", fizz_buzz(15)
# #     assert_equal "Buzz", fizz_buzz(5)
# #     assert_equal "Fizz", fizz_buzz(3)
# #     assert_equal "2", fizz_buzz(2)
# #   end
# # end