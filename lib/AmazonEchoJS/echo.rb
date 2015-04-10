
require 'watir-webdriver'
require "watir-webdriver/wait"

module AmazonEchoJS
  class Echo
    
    ECHO_URL = 'http://echo.amazon.com/spa/index.html#settings/dialogs'
    REFRESH_TIME_IN_MINUTES = 32
    
    attr_accessor :browser, :last_command, :running, :username, :password, :callback_url
  
    def initialize(username, password, callback_url)
      @callback_url = callback_url
      @username = username
      @password = password
      @last_command = ""
      @running = true #allows us to enter first keep_alive loop
      #keep_alive
    end
    
    def kill_browser
      if @running
        (@browser.close rescue nil) if @browser
        @running = false
        @browser = nil
      end
    end
    
    def keep_alive
      while @running
        begin
          #kill_browser no need to kill browser, just refresh the page.
          sleep(1)
          open_browser
          start_watcher
          sleep(60*REFRESH_TIME_IN_MINUTES)
        rescue Exception => e
          puts e.message
        ensure
          kill_browser
          puts "Killed browser."
          #@running = false #keep running even if error encountered.
        end
      end
    end
    
    def open_browser
      @running = true
      
      # was unable to get phantomjs to see ajax updates. This would be the prefered browser to handle headless monitoring.
      # capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36")
      # driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities
      # @browser = Watir::Browser.new driver
      @browser ||= Watir::Browser.new
      @browser.goto ECHO_URL
      Watir::Wait.until { waiting_to_load }
      if @browser.url.match(/www\.amazon\.com\/ap\/signin/)
        login
      end
    end
    
    def waiting_to_load
      loaded=false
      timeout = Time.now+30
      while !loaded && Time.now < timeout
        begin
          loaded = @browser.text.include?('History') || @browser.text.include?("Sign in")
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          puts e.message
          sleep 1 
          retry
        rescue Exception => e
          puts e.message
          return false
        end
        sleep 1
      end
      return true
    end
  
    def login
      email = @browser.text_field(name: 'email')
      email.wait_until_present
      email.set @username
      @browser.text_field(name: 'password').set @password
      @browser.button(id: "signInSubmit-input").click
      sleep 1
      @browser.goto ECHO_URL
    end
    
    def start_watcher

      Watir::Wait.until { waiting_to_load }
      @browser.execute_script("
        var lastCommand = '"+@last_command+"';
        $(document).ajaxComplete(function(){
          command = $('.dd-title.d-dialog-title').first().text()
          if(lastCommand != command){
            $.get('#{@callback_url}?q='+command)
            lastCommand = command;
            console.log(command);
          }
        })
      ")
      puts "Started Watcher JS."
    end
  end
end