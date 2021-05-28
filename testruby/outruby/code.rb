module DeepFreezable
  def deep_freeze(array_or_hash)
    case array_or_hash
    
    when Array
        array_or_hash.each do |element|
          element.freeze
        end
     
    when Hash 
      array_or_hash.each do |key, value|
        key.freeze
        value.freeze
      end
    end  
      array_or_hash.freeze #注意が、フリーズメソッドがレシーバ自身を返すので、当引数に入った値がそのまま返る 
  end
end





