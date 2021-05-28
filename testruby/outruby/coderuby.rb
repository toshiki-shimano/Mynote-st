require_relative "./code.rb"

class Team
   extend DeepFreezable

   COUNTRIES = deep_freeze(["Japan", "Us", "India"])
end

class Bank
   extend DeepFreezable

   CURRENCIES = deep_freeze({"Japan" => "yen", "Us" => "dollar", "India" => "rupee"})
end







