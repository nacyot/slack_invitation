require 'selenium-webdriver'
require 'singleton'
require 'headless'

module SlackInvitation
  class Invitator
    include Singleton

    attr_writer :team, :admin_email, :admin_password

    def initialize
      @driver = nil
      @headless = nil
    end
    
    def start
      @driver = Selenium::WebDriver.for :firefox
      target_size = Selenium::WebDriver::Dimension.new(1024, 768)
      @driver.manage.window.size = target_size      
    end

    def quit
      @driver.quit
    end

    def headless_start
      @headless = Headless.new
      @headless.start
    end
    
    def headless_destroy
      @headless.destroy
    end
    
    def invite(email)
      login
      send_invitation_mail(email)
      test_success
    end

    def config(team, email, password)
      @team = team
      @admin_email = email
      @admin_password = password
    end

    private
    
    def login
      @driver.navigate.to slack_url
      @driver.find_element(:id, 'email').send_keys(@admin_email)
      @driver.find_element(:id, 'password').send_keys(@admin_password)
      @driver.find_element(:id, 'signin_btn').click
      true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
    end

    def send_invitation_mail(email)
      return false if email !~ /@/
      
      tries ||= 0
      @driver.navigate.to invitation_url
      wait tries
      @driver.find_element(:class, 'email_field').send_keys(email)
      @driver.find_element(:class, 'api_send_invites').click
      wait tries
    rescue Selenium::WebDriver::Error::NoSuchElementError
      wait tries
      retry unless (tries += 1) == 5
      return false
    end

    def test_success
      error = @driver.find_element(:class, 'error_msg').displayed?
      success = @driver.find_element(:class, 'seafoam_green').displayed?

      return true if success
      return false if error
    end
    
    def slack_url
      "http://#{ @team }.slack.com/"
    end

    def invitation_url
      "https://#{ @team }.slack.com/admin/invites/full"      
    end
    
    def wait(try = nil)
      sleep(3) unless try
      sleep(0.5 + try*1) if try
    end
  end
end
