class FileReader

  def read_simple(filename) #Чтение простых файлов (1 элемент = 1 строчка)
    begin
      f = File.new(filename, 'r:UTF-8')
      lines = f.readlines
      f.close
      lines
    rescue Errno::ENOENT
      abort "Файл #{filename} не найден"
    end
    lines
  end
  
  def read_complex(filename) #Чтение сложных файлов (1 элемент = 4 строчки)
    begin
      f = File.new(filename, 'r:UTF-8')
      hashes = []
      until f.eof? do
        hash = {}
        hash[:description] = f.readline
        hash[:choice1] = f.readline
        hash[:choice2] = f.readline
        hash[:choice3] = f.readline
        hashes << hash
      end
      f.close
    rescue Errno::ENOENT
      abort "Файл #{filename} не найден"
    end
    hashes
  end

end