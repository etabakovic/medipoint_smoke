# Automated test script execution setup

In order to be able to run automated test script available in this repository, follow steps below:

1\. Install RVM

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
```
2\. Install ruby 2.1.3
```
rvm install 2.1.3
```
If another version of ruby already exists on RVM, do following to switch to newly installed ruby:
```
rvm --default use 2.1.3
```
3\. Clone the repository

4\. Install gems from Gemfile

Once repository cloned, go to __test/functional/rspec__ and execute following:
```
gem install bundler -v 1.12.5
bundle install
```

5\. Runing the test script

Following paramaters are available for running a script on Saucelabs:
- saucelabs: Used to define if test is going to be run on Saucelabs or on local machine. **true** is the default value, **false** is used for local execution
- env_name: Set of predefined values used in test script. medipoint_test is a default environment defined and the only environment defined currently, other can be defined and specified in users.yaml
- operating_system: OS X 10.8 - OS X 10.11, macOS 10.12, Linux, Windows XP, Windows 7, Windows 8, Windows 8.1, Windows 10. Default operating system defined is **OS X 10.11**
- browser: firefox, chrome, safari (only OS X), internet_explorer (only Windows), edge (only Windows 10), opera (Windows XP, Windows 7 and Linux). Default browser defined is **firefox**
- browser_version: Highly dependent on operating system and browser selected. See https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/ for more details. Default version defined is **47**
- resolution: Used to define a screen resolution. Depends on operating system, browser and browser version selected. See link above for more details. Default resolution defined is **1600x1200**
- sauce_username: It is a user name used for login to Saucelabs
- sauce_access_key: It is a key that can be found in My Account section once logged to Saucelabs.
- test_name: It is a name given to automated test in Saucelabs

All parameters are optional since there are default values are defined in cloud_config.rb. If any of the parameters is defined when running a script those will override the default ones. Also, since I am using Saucelabs trial, script will not work after 14 days of my account trial expires. For local run, only Saucelabs and env_name are applicable. All other parameters are Saucelabs specific.

If the test script is going to be run locally, ensure Firefox web browser is installed on machine where the test script is going to be run

Note: Test script might not be running properly on latest Firefox browser versions due to incompatibility between selenium-webdriver and Firefox browser version. Based on https://github.com/SeleniumHQ/selenium/blob/master/dotnet/CHANGELOG, selenium-webdriver 2.51.0 is tested with Firefox 38, 43 and 44. Currently installed selenium-webdriver version is 2.53.4.

Example command for test script execution on Saucelabs with all available parameters is given below:
```
saucelabs=true env_name=medipoint_test operating_system='Windows 10' browser=chrome browser_version=55 resolution=1600x1200 sauce_username=emirTest sauce_access_key=ef8d62c4-8e33-4831-98b6-3fa57f58d4ca test_name='Automated Test' rspec ./spec/smoke_spec.rb
```

Example command for test script exceution on local machine with all relevant parameters is given below:
```
saucelabs=false env_name=medipoint_test bundle exec rspec ./spec/smoke_spec.rb
```

For more information on Saucelabs platforms supportted and other details, see https://saucelabs.com/platforms

