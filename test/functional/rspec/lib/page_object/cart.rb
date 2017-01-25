class Cart < Homepage

	def product_name(code)
		#@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr/td[@class='product_detail']/a/h2[text()='#{name}']")
		@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr/td[@class='product_detail']/span[@content='#{code}']")
		#@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/a[h2='#{full_name}']]/td[@class='product_detail']/a/h2")	
	end

	def product_amount(code)
		#@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/a[h2='#{name}']]/td[@class='product_amount']/input[@class='item-amount']")
		@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/span[@content='#{code}']]/td[@class='product_amount']/input[@class='item-amount']")
	end

	def product_price(code)
		#@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/a[h2='#{name}']]/td[@class='product_price']/span[@class='price large']")
		@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/span[@content='#{code}']]/td[@class='product_price']/span[@class='price large']")	
	end

	def product_remove(code)
		#@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/a[h2='#{name}']]/td[@class='product_action']/a")
		@browser.find_element(:xpath, "//section[@class='cart']/table[@class='cart_detail']/tbody/tr[td[@class='product_detail']/span[@content='#{code}']]/td[@class='product_action']/a")
	end

	def discount
		@browser.find_element(:id, 'KortingDiv')
	end

	def subtotal
		@browser.find_element(:xpath, "//div[@class='cart_summary']/table//table/tbody/tr[@class='sub-total']/td[@class='prices']")
	end

	def shipping
		@browser.find_element(:xpath, "//div[@class='cart_summary']/table//table/tbody/tr[@class='shipping']/td[@class='prices']")
	end

	def total_discount
		@browser.find_element(:xpath, "//div[@class='cart_summary']/table//table/tbody/tr[@class='total-discount']/td[@class='prices']")
	end

	def total
		@browser.find_element(:xpath, "//div[@class='cart_summary']/table/tfoot/tr[@class='total']/td[@class='prices']")
	end

end