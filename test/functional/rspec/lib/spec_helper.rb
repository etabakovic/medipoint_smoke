# Require common gems + helpers for before/after hooks
require 'net/http'
require 'uri'
require 'rspec'
require 'yaml'
#require 'watir-scroll'
#require 'watir-webdriver'
require 'selenium-webdriver'
require 'require_all'
require 'titleize'

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
    case ENV['host'] 
    when 'saucelabs'
      caps = Selenium::WebDriver::Remote::Capabilities.send(ENV['browser'])
      caps.version = ENV['browser_version']
      caps.platform = ENV['operating_system']
      #caps[:name] = example.metadata[:full_description]
      @browser = Selenium::WebDriver.for(:remote, url: "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub",
      desired_capabilities: caps)
      @homepage = homepage(@browser)
    else
      @browser = initialize_browser
      @homepage = homepage(@browser)
    end
  end

  config.after(:all) do
    @browser.quit()
  end

  # ********************************************************
  # global AFTER :ALL hook (close browser)
  # ********************************************************
  # config.after(:all) do # close browser after each test
  #   puts "\n>Test ended, closing the browser"
  #   @homepage.close
  #   puts "\n********************************"
  #   puts "********** Test Ended **********"
  #   puts "********************************"
  # end
end

# **********************************************************************************************
# load corresponding environment from YML based on --options in .rspec, used by BEFORE :ALL hook
# **********************************************************************************************
def load_config()
  rspec_file = '.rspec' 
  #env = ENV['ENV_NAME']
  #puts "\n>Loading RSpec configuration for: " + env.to_s
  full_config = YAML::load(File.open('./config/rspec.yaml')) # full YML
  puts "\n>Loaded RSpec configuration: " + full_config['MEDIPOINT'].to_s # only section of YML that is relevant for the particular environment
  return full_config['MEDIPOINT'] # only section of YML that is relevant for the particular environment
end

# *****************************************************************************
# initialize the browser, used by BEFORE :ALL hook
# *****************************************************************************
def initialize_browser
  puts "\n>Initializing Firefox browser"
  client = Selenium::WebDriver::Remote::Http::Default.new
  @browser = Selenium::WebDriver.for :firefox, :http_client => client
  @browser.manage.timeouts.page_load = 10
  #@browser = Watir::Browser.new driver
  return @browser

  #@browser = Watir::Browser.new :firefox
  #@browser.send_keys :f11
  #@homepage = Homepage.new(@browser)
  #return @homepage
end

def homepage(browser)
  #browser.send_keys :f11
  @homepage = Homepage.new(browser)
  return @homepage
end