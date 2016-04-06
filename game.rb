class Game

  def initialize(choice,name)
    case choice #Определяем размер лабиринта страха и количество жизней
      when 1
        @size = 15
        @life = 10
      when 2
        @size = 30
        @life = 15
      when 3
        @size = 45
        @life = 20
      else
        abort "Что-то пошло не так"
    end

    current_path = File.dirname(__FILE__)
    reader = FileReader.new

    @monster_rooms = reader.read_from_file(current_path + "/data/monster_rooms.txt") #Загружаем список комнат с монстрами
    @monster_fight_good = reader.read_from_file(current_path + "/data/fight_good.txt") #загружаем список удачных вариантов исхода битвы с монстром
    @monster_fight_bad = reader.read_from_file(current_path + "/data/fight_bad.txt") #загружаем список неудачных вариантов исхода битвы с монстром
    @monster_friend_good = reader.read_from_file(current_path + "/data/befriend_good.txt") #загружаем список удачных вариантов исхода дружбы с монстром
    @monster_friend_bad = reader.read_from_file(current_path + "/data/befriend_bad.txt") #загружаем список удачных вариантов исхода дружбы с монстром
    @monster_run_good = reader.read_from_file(current_path + "/data/run_good.txt") #загружаем список удачных вариантов исхода бегства от монстра
    @monster_run_bad = reader.read_from_file(current_path + "/data/run_bad.txt") #загружаем список удачных вариантов исхода бегства от монстра
    @riddles = reader.read_from_file(current_path + "/data/riddles.txt") #загружаем список загадок
    @riddlers = reader.read_from_file(current_path + "/data/riddle_givers.txt") #загружаем список загадывателей загадок
    @titles = reader.read_from_file(current_path + "/data/player_titles.txt") #загружаем список титулов игрока
    @name = name

    puts "\nТвое приключение начинается..."
    #Блок для счета очков
    @room_number = 0 #Счетчик комнат, изначально 0
    @potions = 0 #Счетчик найденных лечебных зелий
    @dead_monster = 0 #Подсчет убитых монстров
    @friend_monster = 0 #Подсчет монстров, с которыми удалось подрухиться
    @run_monster = 0 #Подсчет монстров, он которых удалось убежать
    @guessed_riddle = 0 #Счетчик угаданных загадок
    @math_solved = 0 #Cчетчик решенных примеров
    @score = 0 # Счет

      end

  def next_room #Метод генерации следующей комнаты
    until @life == 0 || @room_number == @size do
      puts
      puts "У тебя #{@life} жизней"
      action = nil
      @room_number += 1
      puts "\nКомната #{@room_number} из #{@size}"
      @room_type = rand(4) #Выбор типа комнаты случайным образом (существуют 4 типа комнаты: с монстрами, с загадками, с примерами и пустая)
      case @room_type
        when 0 #Выводим случайную комнату с монстром
          puts @monster_rooms.sample
          random_count = rand(2)
          until action == 1 || action == 2 || action == 3 do
            puts "\nВведи 1, 2 или 3"
            action = STDIN.gets.chomp.to_i
          end
          if action == 1 && random_count == 0
            puts @monster_fight_good.sample
            @dead_monster += 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          elsif action == 1 && random_count == 1
            puts @monster_fight_bad.sample
            @life -= 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          elsif action == 2 && random_count == 0
            puts @monster_friend_good.sample
            @friend_monster += 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          elsif action == 2 && random_count == 1
            puts @monster_friend_bad.sample
            @life -= 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          elsif action == 3 && random_count == 0
            puts @monster_run_good.sample
            @run_monster += 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          elsif action == 3 && random_count == 1
            puts @monster_run_bad.sample
            @life -= 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          end
          when 1 #Выводим случайную комнату с загадкой
          puts @riddlers.sample
          puts @riddles.sample
          until action == 1 || action == 2 || action == 3 do
            puts "\nВведи 1, 2 или 3"
            action = STDIN.gets.chomp.to_i
          end
          if action == 2
            puts "\nТы правильно отгадал загадку и путь в следующую комнату теперь открыт"
            @guessed_riddle += 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          else
            puts "\nЭто неправильный ответ! Ты теряешь 1 жизнь"
            @life -= 1
            puts "\nНажми ENTER, чтобы перейти дальше"
            gets
          end
          when 2 #Выводим пустую комнату
          puts "\nТы оказываешься в пустой комнате, тут нет ни монстров, ни загадок! Ты решаешь передохнуть и затем идешь дальше"
          puts "\nНажми ENTER, чтобы перейти дальше"
          gets
          when 3 #Выводим комнату со случайным примером
          puts "\nТы заходишь в комнату, которая выглядит прямо как твой класс в школе, только за партами сидят скелеты! На стене на школьной доске ты видишь надпись: \n\"Если ты правильно решишь этот пример, дверь в следующую комнату откроется, \nНу а если неправильно - то скелеты оживут и нападут на тебя!\""
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
      potion = rand(10) #Есть шанс найти лечебное зелье и восстановить одну жизнь
      if potion == 5
        puts "\nКакая удача!! В сундуке по дороге в следующую комнату обнаружился пузырек с волшебным зельем! У тебя добавилась 1 жизнь"
        puts "\nНажми ENTER, чтобы перейти дальше"
        @potions += 1
        gets
        @life += 1
      end
    end

    (@life == 0) ? @outcome = 0 : @outcome = 1 #записываем результат (0 - проигрыш, 1 - выигрыш)

  end

  def result #Метод вывода результата игры
    case @outcome
    when 0 #Проигрыш
      @score = @dead_monster * 100 + @friend_monster * 100 + @run_monster * 100 + @math_solved * 100 + @guessed_riddle * 100 + @potions * 100
      puts "\nК сожалению, тебе не удалось выбраться из Лабиринта Страха."
      puts "Результаты игры:"
      puts "Пройдено комнат: #{@room_number} из #{@size}"
      puts "Победы над монстрами: #{@dead_monster}"
      puts "Новые друзья-монстры: #{@friend_monster}"
      puts "Удалось убежать от монстров: #{@run_monster}"
      puts "Правильно решено примеров: #{@math_solved}"
      puts "Разгадано загадок: #{@guessed_riddle}"
      puts "Найдено лечебных зелий: #{@potions}"
      puts "Заработано очков: #{@score}"
    when 1 #Выигрыш
      @score = @dead_monster * 100 + @friend_monster * 100 + @run_monster * 100 + @math_solved * 100 + @guessed_riddle * 100 + @life * 100 + @size * 100 + @potions * 100
      puts "\nУРА! Тебе удалось найти выход из Лабиринта Страха!"
      puts "За твои храбрые подвиги тебе присваивается звание:\n#{@name} - #{@titles.sample}"
      puts "Результаты игры:"
      puts "Победы над монстрами: #{@dead_monster}"
      puts "Новые друзья-монстры: #{@friend_monster}"
      puts "Удалось убежать от монстров: #{@run_monster}"
      puts "Правильно решено примеров: #{@math_solved}"
      puts "Разгадано загадок: #{@guessed_riddle}"
      puts "Найдено лечебных зелий: #{@potions}"
      puts "Осталось жизней: #{@life}"
      puts "Заработано очков: #{@score}"
    end
  end

  end
