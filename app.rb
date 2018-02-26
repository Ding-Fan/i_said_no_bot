require 'telegram_bot'
require 'rubygems'
require 'excon'
require 'json'

bot = TelegramBot.new(token: '499559029:AAE7teeLeQIRILtAoR2Ec8fm_qmeuH1HGqY')
ENDPOINT = 'https://random-quote-generator.herokuapp.com/api/quotes/random'
bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)

    message.reply do |reply|
        case command
        when /en/i
            response = Excon.get(ENDPOINT)
          # p JSON.parse(response.body)['quote']
            reply.text = "No.\n\n" << JSON.parse(response.body)['quote']
        else
            reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
        end
        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
    end
end
