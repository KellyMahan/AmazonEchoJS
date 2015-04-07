# AmazonEchoJS

AmazonEchoJS is an executable to monitor Amazon echo for voice commands.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'AmazonEchoJS'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install AmazonEchoJS

## Usage

to run echo_monitor you must provide the username, password, and callback url

    echo_monitor email@domain.com 1234567890 'http://localhost:4567/command'

## Thanks

Thanks to Zach Feldman @zachfeldman for his original work with https://github.com/zachfeldman/alexa-home
Portions of code written by @zachfeldman

## Contributing

1. Fork it ( https://github.com/[my-github-username]/AmazonEchoJS/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
