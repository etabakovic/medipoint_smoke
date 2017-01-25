# Require common gems + helpers for before/after hooks
require 'net/http'
require 'uri'
require 'rspec'
require 'yaml'
require 'selenium-webdriver'
require 'require_all'

#Load all page objects using the require_all gem. This loads all sub-directories, too
require_all './lib/'

# ****************************************************************************************
# RSpec.config prepares common before/after hooks for initializing and closing the browser
# ****************************************************************************************
RSpec.configure do |config|
  config.filter_run_excluding :skip => true

  config.before(:suite) do
    $config = load_config()
  end
  
  # ******************************************************************
  # global BEFORE :ALL hook (initialize browser)
  # ******************************************************************
  config.before(:all) do
    if ENV['saucelabs'] == 'true'
      caps = Selenium::WebDriver::Remote::Capabilities.send(ENV['browser'])
      #caps['seleniumVersion'] = "3.0.3" #Sauce labs does not support latest selenium v 3.x webdriver
      caps['version'] = ENV['browser_version']
      caps['platform'] = ENV['operating_system']
      caps['screenResolution'] = ENV['resolution']
      caps['name'] = ENV['test_name']
      @browser = Selenium::WebDriver.for(:remote, url: "http://#{ENV['sauce_username']}:#{ENV['sauce_access_key']}@ondemand.saucelabs.com:80/wd/hub",
      desired_capabilities: caps)
      @homepage = homepage(@browser)
    else
      @browser = initialize_browser
      @homepage = homepage(@browser)
    end
  end

  # ********************************************************
  # global AFTER :ALL hook (close browser)
  # ********************************************************
  config.after(:all) do
    puts "\n>Test ended, closing the browser"
    @browser.quit()
  end
end

# **********************************************************************************************
# load corresponding environment from YML based on --options in .rspec, used by BEFORE :ALL hook
# **********************************************************************************************
def load_config()
  rspec_file = '.rspec'
  full_config = YAML::load(File.open('./config/users.yaml')) # full YML
  puts "\n>Loaded user configuration for: " + ENV['env_name'].to_s # only section of YML that is relevant for the particular environment
  return full_config[ENV['env_name']] # only section of YML that is relevant for the particular environment
end

# *****************************************************************************
# initialize the browser, used by BEFORE :ALL hook
# *****************************************************************************
def initialize_browser
  puts "\n>Initializing Firefox browser"
  client = Selenium::WebDriver::Remote::Http::Default.new
  @browser = Selenium::WebDriver.for :firefox, :http_client => client
  @browser.manage.timeouts.page_load = 10
  return @browser
end

def homepage(browser)
  @homepage = Homepage.new(browser)
  return @homepage
end