class Login < Homepage

	def username
		@browser.find_element(:id, 'ContentAreaMaster_ContentArea_F38_LoginBestaandeKlanten_txtGebruikersnaam')
	end

	def password
		@browser.find_element(:id, 'ContentAreaMaster_ContentArea_F38_LoginBestaandeKlanten_txtWachtwoord')
	end

	def login
		@browser.find_element(:id, 'ContentAreaMaster_ContentArea_F38_LoginBestaandeKlanten_LoginButton')
	end

end