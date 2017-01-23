describe "Medipoint smoke", :skip => false do

var = Variables.new
#var.items = 1

#search_name = 'Buienradar BR800' 
search_name = 'Insectenvanger'
#full_name = 'Buienradar BR-800 Draadloos Weerstation'
full_name = 'Insectenvanger'
#search_name = 'Draadloos Weerstation'

wait = Selenium::WebDriver::Wait.new(:timeout => 15)

    context "Medipoint" do
      it "opens medipoint homepage" do
            @browser.get($config['url'])
      end

      it "checks page is loaded" do
            wait.until {@homepage.logo}
            expect(@homepage.logo.displayed?).to be true
      end

      it "click on login link" do
      	@homepage.login_header.click
      end

      it "enters username" do
            wait.until {@homepage.goto_login.username}
            @homepage.goto_login.username.send_keys $config['username']
      end

      it "enters password" do
            wait.until {@homepage.goto_login.password}
      	@homepage.goto_login.password.send_keys $config['password']
      end

      it "click on login" do
      	@homepage.goto_login.login.click
      end

      it "check user is logged" do
            wait.until {@homepage.logout_header.displayed?}
            expect(@homepage.logout_header.displayed?).to be true
      end

      it "search for #{search_name} item" do
            @homepage.search.send_keys search_name
            @homepage.search.send_keys :enter
      end

      it "open a #{search_name} item" do
            wait.until {@homepage.goto_main.item_link(search_name)}
            @homepage.goto_main.item_link(search_name).click
      end

      it "#{search_name} item unit price" do
            wait.until {@homepage.goto_main.item_price}
            var.price_s = @homepage.goto_main.item_price.text.gsub(/\s+/,'')
            puts var.price_s
            var.price_f = @homepage.goto_main.item_price.text.gsub(/[^0-9.,]/,'').to_f
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
                  puts var.amount_s
                  var.amount_f = var.items
            end

            it "check item price remained unchanged after item count change" do
                  expect(@homepage.goto_main.item_price.text.gsub(/\s+/,'')).to eq var.price_s
                  var.subtotal = var.price_f*var.amount_f - 0.01
            end
      else
            it "extract and store default item count" do
                  var.amount_s = '1'
                  puts var.amount_s
                  var.amount_f = 1
                  var.subtotal = var.price_f
            end
      end
#=begin
      it "adds #{search_name} item to cart" do
            wait.until {@homepage.goto_main.add_to_cart}
            @homepage.goto_main.add_to_cart.click
      end

      it "goes to cart" do
            wait.until {@homepage.goto_main.view_cart}
            @homepage.goto_main.view_cart.click
      end

      it "check #{full_name} product displayed" do
            wait.until {@homepage.goto_cart.product_name(full_name)}
            @homepage.goto_cart.product_name(full_name).displayed?
      end

      it "checks #{full_name} product count" do
            wait.until {@homepage.goto_cart.product_amount(full_name)}
            #puts @homepage.goto_cart.product_amount(full_name).attribute('value')
            expect(@homepage.goto_cart.product_amount(full_name).attribute('value')).to eq (var.amount_s)
      end

      it "checks #{full_name} product price" do
            wait.until {@homepage.goto_cart.product_price(full_name)}
            #puts var.subtotal.modulo(sprintf("%.2f", var.subtotal).to_f)
            if var.subtotal.modulo(var.subtotal.to_i) > 0
                  new_price = '€' + var.subtotal.to_s
            else
                  new_price = '€' + sprintf("%.0f", var.subtotal) + '.-'
            end
            puts new_price
            expect(@homepage.goto_cart.product_price(full_name).text).to eq new_price
      end

      it "checks subtotal in cart" do
            new_price = '€ ' + sprintf("%.2f", var.subtotal).gsub('.',',')
            puts new_price
            expect(@homepage.goto_cart.subtotal.text).to eq new_price
      end

      it "checks shipping in cart" do
            if var.subtotal >= 50
                  var.shipping = 0
            else
                  var.shipping = 3.95
            end
            shipping = '+ € ' + sprintf("%.2f", var.shipping).gsub('.',',')
            #puts sprintf("%.2f", var.shipping).to_s
            expect(@homepage.goto_cart.shipping.text).to eq shipping
      end

      # it "calculate discount if available" do
      #       if @homepage.goto_cart.discount.displayed?
      #             puts @homepage.goto_cart.discount.text
      #             percent = @homepage.goto_cart.discount.text.split(' ')[2].gsub(/[^0-9.,]/,'').to_f
      #             var.discount = var.subtotal*percent/100
      #       else
      #             var.discount = 0.00
      #       end
      # end

      it "calculate and check discount in cart" do
            if @homepage.goto_cart.discount.displayed?
                  puts @homepage.goto_cart.discount.text
                  percent = @homepage.goto_cart.discount.text.split(' ')[2].gsub(/[^0-9.,]/,'').to_f
                  var.discount = var.subtotal*percent/100
            else
                  var.discount = 0
            end
            #puts sprintf("%.2f", var.discount).to_s
            discount = '- € ' + sprintf("%.2f", var.discount).gsub('.',',')
            expect(@homepage.goto_cart.total_discount.text).to eq discount
      end

      it "check total in cart" do
            var.total = var.subtotal + var.shipping - var.discount
            total = '€ ' + sprintf("%.2f", var.total).gsub('.',',')
            expect(@homepage.goto_cart.total.text).to eq total
      end

      it "#{full_name} product remove" do
            wait.until {@homepage.goto_cart.product_remove(full_name)}
            @homepage.goto_cart.product_remove(full_name).click
            @homepage.goto_main.ok.click
            #sleep 10
      end
#=end
      # it "goes to cart" do
      #       wait.until {@homepage.goto_main.ok}
      #       @homepage.goto_main.ok.click
      #       wait.until {@homepage.shopping_cart.displayed?}
      #       sleep 2
      #       @homepage.shopping_cart.click
      #       sleep 10
      # end
    end

end