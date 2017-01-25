class Signup < Homepage

	def title
		@browser.find_elements(:xpath, "//select[@id='Aanhef']/option")
	end

	def first
		@browser.find_element(:id, 'Voornaam')
	end

	def last
		@browser.find_element(:id, 'Achternaam')
	end

	def street
		@browser.find_element(:id, 'Straat')
	end

	def hno
		@browser.find_element(:id, 'Huisnummer')
	end

	def postal
		@browser.find_element(:id, 'Postcode')
	end

	def city
		@browser.find_element(:id, 'Plaats')
	end

	def email
		@browser.find_element(:id, 'Emailadres')
	end

	def birthdate
		@browser.find_element(:id, 'Geboortedatum')
	end

	def username
		@browser.find_element(:id, 'Gebruikersnaam')
	end

	def password
		@browser.find_element(:id, 'Wachtwoord')
	end

	def confirm_password
		@browser.find_element(:id, 'HerhaalWachtwoord')
	end

	def terms_and_conditions
		@browser.find_element(:id, 'AlgemeneVoorwaarden')
	end

	def submit
		@browser.find_element(:id, 'ContentAreaMaster_ContentArea_ctl00_ctl00_ctl00_ctl00_send')
	end

	def back
		@browser.find_element(:class, 'cancel')
	end

	def signup_success
		@browser.find_element(:xpath, "//div[@class='pagewrap']//h1")
	end

	def continue_shopping
		@browser.find_element(:link, 'Verder winkelen')
	end

end