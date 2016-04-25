require_relative 'lib/game.rb'
require_relative 'lib/file_reader.rb'
require_relative 'lib/codepage_fix.rb'

start_time = Time.now
hour = start_time.strftime('%H').to_i

greeting = case hour
             when 0..4 then 'Доброй ночи'
             when 5..10 then 'Доброе утро'
             when 11..17 then 'Добрый день'
             when 18..22 then 'Добрый вечер'
             when 23..24 then 'Доброй ночи'
             else 'Здравствуй'
           end

# Заставка
puts 'ИГРА "ЛАБИРИНТ СТРАХА"'
sleep 1
puts 'Это очень страшная и ужасная игра!'
sleep 1
puts
puts "#{greeting}, храбрый воин! давай познакомимся" 
puts 'Как тебя зовут?'
name = STDIN.gets.encode("UTF-8").chomp
puts "Приятно познакомится, #{name}!"
puts 'Добро пожаловать в Лабиринт Страха! У-ХА-ХА!'
sleep 1
puts
puts 'Ты входишь в круглую комнату и видишь перед собой три двери.'
size = nil
until size == 1 || size == 2 || size == 3 do #Выбираем размер лабиринта
	puts 'В какую дверь ты пойдешь?'
  puts
	puts '1. В левую дверь с надписью "Маленький лабиринт"'
	puts '2. В среднюю дверь с надписью "Средний лабиринт"'
	puts '3. В правую дверь с надписью "Большой лабиринт"'
	size = STDIN.gets.to_i
end

game = Game.new(size,name)

while game.status == 0 do
  game.next_room
end

game.result

finish_time = Time.now
time_diff = finish_time - start_time

puts "Проведено за игрой - #{time_diff.to_i} секунд"
puts 
puts 'К О Н Е Ц'