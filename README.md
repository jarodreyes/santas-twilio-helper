# Santas Twilio Helper

This is a command-line tool that uses the command `santa` to interact with Santa's helpers in the north pole. This allows the festive parent to surprise their child by having Santa's elves send messages. This was built using Twilio's  REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'santas_twilio_helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install santas_twilio_helper

## Usage

Type `santa help` to see the full list of commands. When you are in a private place without little ones around, type `santa begin` to kick off the setup of the tool.

-- `begin` registers one child name, adds a phone number and stores your zipcode for Dec. 25 fun. This is all stored locally on your machine in santarc.json.
-- `ping` sends a random msg from the northpole. (eg: messages.json)
-- `telegraph` allows you to send a custom message from the northpole.
-- `add_child` allows you to add another child name.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/santas_twilio_helper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
