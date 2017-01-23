class Main < Homepage

	def item_link(name)
		@browser.find_element(:partial_link_text, name)
	end

	def item_price
		@browser.find_element(:class, 'prices').find_element(:class, 'price')
		#@browser.find_element(:xpath, "//div[@class='prices']/span")
	end

	def item_cnt
		@browser.find_element(:id, "ContentAreaMaster_ContentArea_F11_Productbeschrijving_Aantal")
	end

	def add_to_cart
		@browser.find_element(:id, "ContentAreaMaster_ContentArea_F11_Productbeschrijving_lnkAddToCart")
	end

	def ok
		@browser.find_element(:class, 'feedback-note').find_element(:link, 'OK')
	end

	def view_cart
		@browser.find_element(:class, 'feedback-note').find_element(:link, 'Bekijk winkelwagen')
	end

	def no
		@browser.find_element(:class, 'feedback-note').find_element(:link, 'Nee')
	end

end