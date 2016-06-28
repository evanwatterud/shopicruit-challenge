require 'json'
require 'net/http'

sum_cost = 0.0
sum_grams = 0

shopicruit_hash = JSON.parse(Net::HTTP.get('shopicruit.myshopify.com', '/products.json'))

computer_variants = shopicruit_hash["products"].select{ |product| product["product_type"] == "Computer" }.map{ |computer|
  computer["variants"]
}.flatten.sort_by{ |variant| variant["price"].to_i }

keyboard_variants = shopicruit_hash["products"].select{ |product| product["product_type"] == "Keyboard" }.map{ |keyboard|
  keyboard["variants"]
}.flatten.sort_by{ |variant| variant["price"].to_i }

computer_variants.each do |computer_variant|
  keyboard = keyboard_variants.shift

  break unless keyboard

  sum_grams += keyboard["grams"]
  sum_cost += keyboard["price"].to_f

  sum_grams += computer_variant["grams"]
  sum_cost += computer_variant["price"].to_f
end

puts sum_grams
puts sum_cost
