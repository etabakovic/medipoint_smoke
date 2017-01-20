class Homepage < PageContainer

	def logo
		@browser.find_element(:id, 'logo')
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

	def goto_login
		return Login.new(@browser)
	end
end