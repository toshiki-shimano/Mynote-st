UNITS = {m: 1.0, ft: 3.28, in: 39.37}
def convert_length(length, from: :m, to: :m)
    (length / UNITS[from] * UNITS[to]).round(2)
end

# def fizz_buzz(inte)
#     if inte % 15 == 0 && inte >= 15
#         "Fizz Buzz"
#     elsif inte % 5 == 0 && inte >= 5
#         "Buzz"
#     elsif inte % 3 == 0 && inte >= 3
#         "Fizz"
#     else
#           inte.to_s
#     end
# end





