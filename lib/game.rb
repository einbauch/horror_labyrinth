class Game
  
  attr_reader :status

  def initialize(size_choice,name)
    case size_choice #Определяем размер лабиринта страха и количество жизней
      when 1
        @size = 20
        @life = 10
      when 2
        @size = 30
        @life = 15
      when 3
        @size = 45
        @life = 20
      end

    current_path = File.dirname(__FILE__)
    reader = FileReader.new
    
    #Считываем из файлов содержимое комнат и варианты развития событий
    @monster_rooms = reader.read_complex(current_path + '/../data/monster_rooms.txt') #Загружаем список комнат с монстрами
    @monster_fight_good = reader.read_simple(current_path + '/../data/fight_good.txt') #загружаем список удачных вариантов исхода битвы с монстром
    @monster_fight_bad = reader.read_simple(current_path + '/../data/fight_bad.txt') #загружаем список неудачных вариантов исхода битвы с монстром
    @monster_friend_good = reader.read_simple(current_path + '/../data/befriend_good.txt') #загружаем список удачных вариантов исхода дружбы с монстром
    @monster_friend_bad = reader.read_simple(current_path + '/../data/befriend_bad.txt') #загружаем список удачных вариантов исхода дружбы с монстром
    @monster_run_good = reader.read_simple(current_path + '/../data/run_good.txt') #загружаем список удачных вариантов исхода бегства от монстра
    @monster_run_bad = reader.read_simple(current_path + '/../data/run_bad.txt') #загружаем список удачных вариантов исхода бегства от монстра
    @riddles = reader.read_complex(current_path + '/../data/riddles.txt') #загружаем список загадок
    @riddle_givers = reader.read_simple(current_path + '/../data/riddle_givers.txt') #загружаем список загадывателей загадок
    @titles = reader.read_simple(current_path + '/../data/player_titles.txt') #загружаем список титулов игрока
    @name = name

    puts 'Твое приключение начинается!'
    #Блок для счета очков
    @room_number = 0 #Счетчик комнат, изначально 0
    @potions = 0 #Счетчик найденных лечебных зелий
    @dead_monster = 0 #Подсчет убитых монстров
    @friend_monster = 0 #Подсчет монстров, с которыми удалось подрухиться
    @run_monster = 0 #Подсчет монстров, он которых удалось убежать
    @guessed_riddle = 0 #Счетчик угаданных загадок
    @math_solved = 0 #Cчетчик решенных примеров
    @score = 0 # Счет
    @status = 0 #Статус игры (-1 - проигрыш, 0 - игра в процессе, 1 - выигрыш)
  end

  def next_room #Метод генерации следующей комнаты
      cls
      puts "У тебя #{@life} жизней"
      @room_number += 1
      puts
      puts "Комната #{@room_number} из #{@size}"
      puts
      @room_type = rand(1..100) #Выбор типа комнаты случайным образом (существуют 4 типа комнаты: с монстрами, с загадками, с примерами и пустая)
      
      case @room_type
        when 1..30 then monster_room #Выводим случайную комнату с монстром
        when 31..60 then riddle_room #Выводим случайную комнату с загадкой
        when 61..70 then empty_room #Выводим пустую комнату
        when 71..100 then math_room #Выводим комнату со случайным примером
      end
      
      potion = rand(10) #Есть шанс найти лечебное зелье и восстановить одну жизнь
      
      if potion == 5
        puts
        puts 'Какая удача!! В сундуке по дороге в следующую комнату обнаружился пузырек с волшебным зельем! У тебя добавилась 1 жизнь'
        puts 'Нажми ENTER, чтобы перейти дальше'
        @potions += 1
        gets
        @life += 1
      end

      @status = -1 if @life <= 0
      @status = 1 if @room_number >= @size
  end

  def monster_room # генерация комнаты с монстром
    room_choice = rand(0..@monster_rooms.length-1)
    
    puts @monster_rooms[room_choice][:description]
    puts
    puts @monster_rooms[room_choice][:choice1]
    puts @monster_rooms[room_choice][:choice2]
    puts @monster_rooms[room_choice][:choice3]
    
    encounter_outcome = rand(1..100)
    action = nil
    
    until action == 1 || action == 2 || action == 3 do
      puts
      puts 'Введи 1, 2 или 3'
      action = STDIN.gets.chomp.to_i
    end
    
    case encounter_outcome
      when 1..50
        case action
          when 1
            puts
            puts @monster_fight_bad.sample
            @life -= 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
          when 2
            puts
            puts @monster_friend_bad.sample
            @life -= 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
          when 3
            puts
            puts @monster_run_bad.sample
            @life -= 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
        end
      when 51..100
        case action
          when 1
            puts
            puts @monster_fight_good.sample
            @dead_monster += 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
          when 2
            puts
            puts @monster_friend_good.sample
            @dead_monster += 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
          when 3
            puts
            puts @monster_run_good.sample
            @dead_monster += 1
            puts
            puts 'Нажми ENTER, чтобы перейти дальше'
            gets
        end
    end
  end

  def riddle_room # генерация комнаты с загадкой
    room_choice = rand(0..@riddles.length-1)
    puts @riddle_givers.sample
    puts
    sleep 1
    puts @riddles[room_choice][:description]
    puts @riddles[room_choice][:choice1]
    puts @riddles[room_choice][:choice2]
    puts @riddles[room_choice][:choice3]
    
    action = nil

    until action == 1 || action == 2 || action == 3 do
      puts
      puts 'Введи 1, 2 или 3'
      action = STDIN.gets.chomp.to_i
    end

    if action == 2
      puts
      puts 'Ты правильно отгадал загадку и путь в следующую комнату теперь открыт'
      puts
      @guessed_riddle += 1
      puts 'Нажми ENTER, чтобы перейти дальше'
      gets
    else
      puts
      puts 'Это неправильный ответ! Ты теряешь 1 жизнь'
      @life -= 1
      puts
      puts 'Нажми ENTER, чтобы перейти дальше'
      gets
    end
  end
  
  def empty_room # генерация пустой комнаты
    puts 'Ты оказываешься в пустой комнате, тут нет ни монстров, ни загадок! Ты решаешь передохнуть и затем идешь дальше'
    puts
    puts 'Нажми ENTER, чтобы перейти дальше'
    gets
  end
  
  def math_room # генерация комнаты с примером
    puts "Ты заходишь в комнату, которая выглядит прямо как твой класс в школе, только за партами сидят скелеты! На стене на школьной доске ты видишь надпись: \n\"Если ты правильно решишь этот пример, дверь в следующую комнату откроется, \nНу а если неправильно - то скелеты оживут и нападут на тебя!\""
    math_one = rand (1..15)
    math_two = rand (1..15)
    math_sign = rand (2)
    if math_sign == 0
      puts "\nПример: #{math_one} + #{math_two} = ?"
      action = STDIN.gets.to_i
      if action == math_one + math_two
        @math_solved += 1
        puts "\nНа доске появляется надпись: \"Это правильный ответ!\""
        puts "\nДверь в следующую комнату открылась! Можно идти дальше!"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      else
        @life -= 1
        puts "\nНа доске появляется надпись: \"Это неправильный ответ! Правильный ответ - #{math_one + math_two}\""
        puts "\nСкелеты оживают и набрасываются на тебя! Хотя тебе и удается от них отбиться, они добавляют тебе пару новых синяков и шишек. Ты теряешь 1 жизнь"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      end
    elsif math_sign == 1 && math_one >= math_two
      puts "\nПример: #{math_one} - #{math_two} = ?"
      action = STDIN.gets.to_i
      if action == math_one - math_two
        @math_solved += 1
        puts "\nНа доске появляется надпись: \"Это правильный ответ!\""
        puts "\nДверь в следующую комнату открылась! Можно идти дальше!"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      else
        @life -= 1
        puts "\nНа доске появляется надпись: \"Это неправильный ответ! Правильный ответ - #{math_one - math_two}\""
        puts "\nСкелеты оживают и набрасываются на тебя! Хотя тебе и удается от них отбиться, они добавляют тебе пару новых синяков и шишек. Ты теряешь 1 жизнь"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      end
    elsif math_sign == 1 && math_one < math_two
      puts "\nПример: #{math_two} - #{math_one} = ?"
      action = STDIN.gets.to_i
      if action == math_two - math_one
        @math_solved += 1
        puts "\nНа доске появляется надпись: \"Это правильный ответ!\""
        puts "\nДверь в следующую комнату открылась! Можно идти дальше!"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      else
        @life -= 1
        puts "\nНа доске появляется надпись: \"Это неправильный ответ! Правильный ответ - #{math_two - math_one}\""
        puts "\nСкелеты оживают и набрасываются на тебя! Хотя тебе и удается от них отбиться, они добавляют тебе пару новых синяков и шишек. Ты теряешь 1 жизнь"
        puts "\nНажми ENTER, чтобы перейти дальше"
        gets
      end
    end
  end
  
  def cls
    system 'clear' or system 'cls'
  end
  
  def result #Метод вывода результата игры
    cls
    case @status
    when -1 #Проигрыш
      @score = @dead_monster * 100 + @friend_monster * 100 + @run_monster * 100 + @math_solved * 100 + @guessed_riddle * 100 + @potions * 100
      puts
      puts 'К сожалению, тебе не удалось выбраться из Лабиринта Страха.'
      puts
      puts 'Результаты игры:'
      puts "Пройдено комнат: #{@room_number} из #{@size}"
      puts "Победы над монстрами: #{@dead_monster}"
      puts "Новые друзья-монстры: #{@friend_monster}"
      puts "Удалось убежать от монстров: #{@run_monster}"
      puts "Правильно решено примеров: #{@math_solved}"
      puts "Разгадано загадок: #{@guessed_riddle}"
      puts "Найдено лечебных зелий: #{@potions}"
      puts
      puts "Заработано очков: #{@score}"
    when 1 #Выигрыш
      @score = @dead_monster * 100 + @friend_monster * 100 + @run_monster * 100 + @math_solved * 100 + @guessed_riddle * 100 + @life * 100 + @size * 100 + @potions * 100
      puts
      puts 'УРА! Тебе удалось найти выход из Лабиринта Страха!'
      puts 'За твои храбрые подвиги тебе присваивается звание:'
      puts "#{@name} - #{@titles.sample}"
      puts
      puts 'Результаты игры:'
      puts "Победы над монстрами: #{@dead_monster}"
      puts "Новые друзья-монстры: #{@friend_monster}"
      puts "Удалось убежать от монстров: #{@run_monster}"
      puts "Правильно решено примеров: #{@math_solved}"
      puts "Разгадано загадок: #{@guessed_riddle}"
      puts "Найдено лечебных зелий: #{@potions}"
      puts "Осталось жизней: #{@life}"
      puts
      puts "Заработано очков: #{@score}"
    end
  end

end
