require 'pry'

def consolidate_cart(cart)
final_hash = {}
cart.each  do |element_hash| 
  element_name = element_hash.keys[0]


 if final_hash.has_key?(element_name)
   final_hash[element_name][:count] += 1 
   
 else  
   final_hash[element_name] = {count: 1,
   price: element_hash[element_name] [:price],
   clearance: element_hash[element_name][:clearance]
   }

 end

end 
final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
  item = coupon[:item]
  if cart[item]
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
       cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        cart[item][:count] -= coupon[:num]
    
    elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON") 
       cart["#{item} W/COUPON"][:count] += coupon[:num] 
       cart[item][:count] -= coupon[:num]
      end

    end
   end
cart
end


def apply_clearance(cart)
cart.each do |product_name, stats|
  stats[:price] -= stats[:price] * 0.2 if stats[:clearance]
end
cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
 cart_with_coupons_applied = apply_coupons(consol_cart, coupons)
  cart_with_discounts_applied = apply_clearance(cart_with_coupons_applied)
 
 total = 0.0
  cart_with_discounts_applied.keys.each do |item|
    total += cart_with_discounts_applied[item][:price]*cart_with_discounts_applied[item][:count]
  end
  total > 100.00 ? (total * 0.90).round : total

end
