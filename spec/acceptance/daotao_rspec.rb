require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "DaotaoRspec" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://qlgd.hpu.edu.vn/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_daotao_rspec" do
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Đăng nhập").click
    @driver.find_element(:id, "username").clear
    @driver.find_element(:id, "username").send_keys "dungth@hpu.edu.vn"
    @driver.find_element(:id, "password").clear
    @driver.find_element(:id, "password").send_keys "dungth123654"
    @driver.find_element(:id, "login-submit").click
    @driver.find_element(:link, "Đào tạo").click
    @driver.find_element(:link, "Phòng trống").click
    @driver.find_element(:css, "input.span2").click
    @driver.find_element(:css, "input.span2").clear
    @driver.find_element(:css, "input.span2").send_keys "20/03/2014"
    @driver.find_element(:xpath, "//div[@id='phongtrong']/div/div/button").click
    !60.times{ break if (element_present?(:css, "#phongtrong > div > div.table-responsive > table.table.table-bordered") rescue false); sleep 1 }
    element_present?(:css, "#phongtrong > div > div.table-responsive > table.table.table-bordered").should be_true
  end
  
  def element_present?(how, what)
    ${receiver}.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    ${receiver}.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = ${receiver}.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
