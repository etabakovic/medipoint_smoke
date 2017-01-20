describe "Medipoint smoke", :skip => false do

wait = Selenium::WebDriver::Wait.new(:timeout => 15)

    context "Medipoint" do
      it "opens medipoint homepage" do
      	@browser.get($config['url'])
      end

      it "checks page is loaded" do
      	wait.until {@homepage.logo.displayed?}
      end

      it "click on login link" do
      	@homepage.login_header.click
      end

      it "enters username" do
      	@homepage.goto_login.username.send_keys $config['username']
      end

      it "enters password" do
      	@homepage.goto_login.password.send_keys $config['password']
      end

      it "click on login" do
      	@homepage.goto_login.login.click
      end

      it "check user is logged" do
      	wait.until {@homepage.logout_header.displayed?}
      end
    end

end