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
        puts "#{Paint['Santa', :red]} is still in the Northpole, we'll keep you aware of his movements. -the elves"
      end

      desc 'telegraph MSG', "Send a text message as Santa's helper to the phone we have listed"
      def telegraph(message)
        file = File.read('santarc.json')
        data_hash = JSON.parse(file)
        phone = data_hash['telephone']

        message = @@client.account.messages.create(
          :from => @@twilio_number,
          :to => phone,
          :body => message
        )

        puts "#{Paint['Santa', :red]} has approved that communication and we'll forward to the appropriate phone soon. -the elves"
      end

    end
  end
end