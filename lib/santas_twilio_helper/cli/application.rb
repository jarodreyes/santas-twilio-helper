require 'thor'
require 'paint'
require 'json'
require 'twilio-ruby'

module SantasTwilioHelper
  module Cli
    class Application < Thor

      # Class constants
      @@twilio_number = ENV['TWILIO_NUMBER']
      @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

      include Thor::Actions

      desc 'begin', 'Register yourself as one of Santas helpers'
      def begin
        invoke :setup
        say("#{Paint["Hi I'm one of Santa's Twilio Elves, and I'm about to deputize you as an ambassador to Santa. To get started I need your name.", :red]}")
        santa_helper = ask("Parent Name: ")

        children = []
        say("Great Gumdrops. We also need your child's name to verify they are on Santa's list. ")
        child = ask("Child Name: ")
        children.push(child)

        say("Fantastic. You can always add more children by running add_child later.")
        say("Next I need to know your telephone number so Santa's helpers can get in touch with you.")
        telephone = ask("#{Paint['Telephone Number: ', :red]}")

        say("The last thing I need is your city so we can verify we have the correct location for #{child}.")
        zip_code = ask("#{Paint['Zip Code: ', :blue]}")

        data = {
          'santa_helper' => santa_helper,
          'children' => children,
          'telephone' => telephone,
          'zip_code'=> zip_code
        }

        write_file(data)

        say("#{Paint["Okay you're off to the races. You can type `santa help` at any time to see the list of available commands.", "#55C4C2"]}")
      end

      no_commands {
        def write_file(data_hash)
          create_file "santarc.json", "// Your Santas Helper configuration.\n #{data_hash.to_json}", :force => true
        end

        def sendMessage(msg)
          file = File.read('santarc.json')
          data_hash = JSON.parse(file)
          phone = data_hash['telephone']
          children = english_join(data_hash['children'])
          msg = "Hi #{children}. #{msg} - the elves"
          message = @@client.account.messages.create(
            :from => @@twilio_number,
            :to => phone,
            :body => msg
          )
        end

        def english_join(array = nil)
          return array.to_s if array.nil? or array.length <= 1
          array[0..-2].join(", ") + " and " + array[-1]
        end
      }
      
      desc 'add_child NAME', 'Add child to Santas registry'
      def add_child(name)
        file = File.read('santarc.json')
        data_hash = JSON.parse(file)
        children = data_hash['children']
        children.push name
        data_hash['children'] = children
        puts data_hash

        write_file(data_hash)
        puts "Added #{name} to children"
      end

      desc 'ping', 'See where Santa is right now'
      def ping
        file = File.read('messages.json')
        messages = JSON.parse(file)
        santaMs = messages['SANTA_SNIPPETS']
        a = rand(0..(santaMs.length-1))
        msg = santaMs[a]
        sendMessage(msg)
      end

      desc 'telegraph MSG', "Send a text message as Santa's helper."
      
      # Longer description when `santa help telegraph` is called.
      long_desc <<-LONGDESC
      `santa telegraph` will send any message to the phone number you entered on setup.

      "You can optionally specify a second parameter, which will insert a time delay (in seconds) so that your messages can be sent while you or the phone are within eyesight of your little ones."

      #{Paint["> $ santa telegraph 'Santa was wondering if Anna likes red things?' --delay 200", "#55C4C2"]}
      LONGDESC

      option :delay, :type => :numeric, :default => 0
      def telegraph(message)
        puts "delay: #{options[:delay]}" if options[:delay]
        sleep(options[:delay])
        puts Paint["sending message as SMS...", :red]
        sendMessage(message)
        puts "message sent: #{message}"
        puts "#{Paint["Santa has approved that communication and we'll forward to the appropriate phone soon. -the elves", :white]}"
      end

    end
  end
end