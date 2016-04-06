require_relative "game.rb"
require_relative "file_reader.rb"
require_relative "codepage_fix.rb"

puts "\nИГРА \"ЛАБИРИНТ СТРАХА\""
sleep 1
puts "\nЭто очень страшная и ужасная игра!"
sleep 1
puts "\nНо если ты не боишься, то давай познакомимся!" # Заставка
puts "Как тебя зовут?"
name = STDIN.gets.encode("UTF-8").chomp #Узнаем имя
puts "\nПриятно познакомится, #{name}!"
#gender = nil
#until gender == "мальчик" || gender == "девочка" #Узнаем пол, может пригодится потом
#puts "\nСкажи, ты мальчик или девочка?"
#gender = STDIN.gets.chomp.encode("UTF-8").downcase
#end
puts "\nДобро пожаловать в Лабиринт Страха! У-ХА-ХА!"
puts "\nТы входишь в первую комнату и видишь перед собой три двери."
choice = nil
until choice == 1 || choice == 2 || choice == 3 do #Выбираем размер лабиринта
	puts "\nВ какую дверь ты пойдешь?"
	puts "1. В левую дверь с надписью \"Маленький лабиринт\""
	puts "2. В среднюю дверь с надписью \"Средний лабиринт\""
	puts "3. В правую дверь с надписью \"Большой лабиринт\""
	choice = STDIN.gets.to_i
end

game = Game.new(choice,name)

game.next_room

game.result

puts "К О Н Е Ц"