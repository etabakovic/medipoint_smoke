describe "Medipoint smoke", :skip => false do

  var = Variables.new
  var.items = 3 #item count for an article searched
  search_name = 'Buienradar BR1000' #name of the article searched for
  #search_name = 'Buienradar BR800'
  #search_name = 'Insectenvanger'

  wait = Selenium::WebDriver::Wait.new(:timeout => 15)

  context "Access medipoint homepage" do
    it "open medipoint homepage" do
      @browser.get($config['url'])
    end

    it "check page is loaded" do
      wait.until {@homepage.logo}
      expect(@homepage.logo.displayed?).to be true
    end
  end

  context "Signup" do
    it "go to signup page" do
      @homepage.signup.click
    end

    it "select title" do
      wait.until {@homepage.goto_signup.title}
      @homepage.goto_signup.title.each do |op|
        if (op.attribute('value') == $config["title"]) 
            op.click
            break
        end
      end
    end

    it "enter first name" do
      @homepage.goto_signup.first.send_keys $config["firstname"]
    end

    it "enter last name" do
      @homepage.goto_signup.last.send_keys $config["lastname"]
    end

    it "enter street" do
      @homepage.goto_signup.street.send_keys $config["street"]
    end

    it "enter house number" do
      @homepage.goto_signup.hno.send_keys $config["hno"]
    end

    it "enter postal code" do
      @homepage.goto_signup.postal.send_keys $config["postal"]
    end

    it "enter city" do
      @homepage.goto_signup.city.send_keys $config["city"]
    end

    it "enter email" do
      if $config["random"]
        email = $config["username"] + Time.now.to_i.to_s + '@test.com'
        @homepage.goto_signup.email.send_keys email
      else
        @homepage.goto_signup.email.send_keys $config["email"]
      end
    end

    it "enter birth date" do
      @homepage.goto_signup.birthdate.send_keys $config["birthdate"]
    end

    it "enter username" do
      if $config["random"]
        var.username = $config["username"] + Time.now.to_i.to_s
        @homepage.goto_signup.username.send_keys var.username
      else
        @homepage.goto_signup.username.send_keys $config["username"]
      end
    end

    it "enter password" do
      @homepage.goto_signup.password.send_keys $config["password"]
    end

    it "confirm password" do
      @homepage.goto_signup.confirm_password.send_keys $config["password"]
    end

    it "accept terms and conditions" do
      @homepage.goto_signup.terms_and_conditions.click
    end

    it "submit form" do
      @homepage.goto_signup.submit.click
    end

    it "check signup was successful" do
      wait.until {@homepage.goto_signup.signup_success}
      expect(@homepage.goto_signup.signup_success.text).to eq 'Bedankt voor uw registratie'
      expect(@homepage.goto_signup.continue_shopping.displayed?).to be true
    end
  end

  context "Login" do
    it "click on login link" do
    	@homepage.login_header.click
    end

    it "enter username" do
      wait.until {@homepage.goto_login.username}
      if $config["random"]
        @homepage.goto_login.username.send_keys var.username
      else
        @homepage.goto_login.username.send_keys $config['username']
      end
    end

    it "enter password" do
      wait.until {@homepage.goto_login.password}
    	@homepage.goto_login.password.send_keys $config['password']
    end

    it "click on login" do
    	@homepage.goto_login.login.click
    end
  end

  context "Search and add item to cart" do
    it "check user is logged" do
      wait.until {@homepage.logout_header.displayed?}
      expect(@homepage.logout_header.displayed?).to be true
    end

    it "search for #{search_name} item" do
      @homepage.search.send_keys search_name
      @homepage.search.send_keys :enter
    end

    it "extract a #{search_name} price" do
      wait.until {@homepage.goto_main.item_link(search_name)}
      var.price_s = @homepage.goto_main.item_search_price(search_name).text.gsub(/\s+/,'')
      var.price_f = @homepage.goto_main.item_search_price(search_name).text.gsub(/[^0-9.,]/,'').to_f
    end

    it "open a #{search_name} item" do
      @homepage.goto_main.item_link(search_name).click
    end

    it "check #{search_name} item unit price" do
      wait.until {@homepage.goto_main.item_price}
      expect(@homepage.goto_main.item_price.text.gsub(/\s+/,'')).to eq var.price_s
    end

    it "extract a #{search_name} product number" do
      wait.until {@homepage.goto_main.item_code}
      var.code = @homepage.goto_main.item_code.attribute('value')
    end

    it "check default item count" do
      wait.until {@homepage.goto_main.item_cnt}
      expect(@homepage.goto_main.item_cnt.attribute('value')).to eq '1'
    end

    if var.items.to_i > 1
      it "set #{search_name} item count to #{var.items.to_s} and store count" do
        @homepage.goto_main.item_cnt.send_keys :backspace
        @homepage.goto_main.item_cnt.send_keys var.items.to_s
        @homepage.goto_main.item_cnt.send_keys :enter
        var.amount_s = var.items.to_s
        var.amount_f = var.items
      end

      it "check item price remained unchanged after item count change" do
        wait.until {@homepage.goto_main.item_price}
        expect(@homepage.goto_main.item_price.text.gsub(/\s+/,'')).to eq var.price_s
        var.subtotal = var.price_f*var.amount_f
      end
    else
      it "extract and store default item count" do
        var.amount_s = '1'
        var.amount_f = 1
        var.subtotal = var.price_f
      end
    end
 
    it "add #{search_name} item to cart" do
      wait.until {@homepage.goto_main.add_to_cart}
      @homepage.goto_main.add_to_cart.click
    end
  end

  context "Cart" do
    it "go to cart" do
      wait.until {@homepage.goto_main.view_cart}
      @homepage.goto_main.view_cart.click
    end

    it "check #{search_name} product displayed in cart" do
      wait.until {@homepage.goto_cart.product_name(var.code)}
      @homepage.goto_cart.product_name(var.code).displayed?
    end

    it "check #{search_name} product count in cart" do
      wait.until {@homepage.goto_cart.product_amount(var.code)}
      expect(@homepage.goto_cart.product_amount(var.code).attribute('value')).to eq (var.amount_s)
    end

    it "check #{search_name} product price in cart" do
      wait.until {@homepage.goto_cart.product_price(var.code)}
      if var.subtotal.modulo(var.subtotal.to_i) > 0
        new_price = '€' + var.subtotal.to_s
      else
        new_price = '€' + sprintf("%.0f", var.subtotal) + '.-'
      end
      expect(@homepage.goto_cart.product_price(var.code).text).to eq new_price
    end

    it "check #{search_name} subtotal in cart" do
      new_price = '€ ' + sprintf("%.2f", var.subtotal).gsub('.',',')
      expect(@homepage.goto_cart.subtotal.text).to eq new_price
    end

    it "check #{search_name} shipping in cart" do
      if var.subtotal >= 50
        var.shipping = 0
      else
        var.shipping = 3.95
      end
      shipping = '+ € ' + sprintf("%.2f", var.shipping).gsub('.',',')
      expect(@homepage.goto_cart.shipping.text).to eq shipping
    end

    it "calculate and check #{search_name} discount in cart" do
      if @homepage.goto_cart.discount.displayed?
        percent = @homepage.goto_cart.discount.text.split(' ')[2].gsub(/[^0-9.,]/,'').to_f
        var.discount = var.subtotal*percent/100
      else
        var.discount = 0
      end
      discount = '- € ' + sprintf("%.2f", var.discount).gsub('.',',')
      expect(@homepage.goto_cart.total_discount.text).to eq discount
    end

    it "check #{search_name} total in cart" do
      var.total = var.subtotal + var.shipping - var.discount
      total = '€ ' + sprintf("%.2f", var.total).gsub('.',',')
      expect(@homepage.goto_cart.total.text).to eq total
    end

    it "#{search_name} product remove" do
      wait.until {@homepage.goto_cart.product_remove(var.code)}
      @homepage.goto_cart.product_remove(var.code).click
      @homepage.goto_main.ok.click
    end
  end
end