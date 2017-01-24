class Homepage < PageContainer

	def logo
		@browser.find_element(:id, 'logo')
	end

	def signup
		@browser.find_element(:link, 'Registreren')
	end

	def login_header
		@browser.find_element(:class, 'EPi-Commerce-loginButton')
	end

	def my_account
		@browser.find_element(:title, /Mijn account/)
	end

	def logout_header
		@browser.find_element(:id, 'F01_Header_HeaderCommands_A1')
	end

	def search
		@browser.find_element(:id, 'F01_Header_txtZoekbox')
	end

	def shopping_cart
		@browser.find_element(:xpath, "//section[@id='shopping-cart']/a")
		#@browser.find_element(:id, 'shopping-cart').find_element(:class, 'items')
	end

	def goto_login
		return Login.new(@browser)
	end

	def goto_main
		return Main.new(@browser)
	end

	def goto_cart
		return Cart.new(@browser)
	end

	def goto_signup
		return Signup.new(@browser)
	end
end