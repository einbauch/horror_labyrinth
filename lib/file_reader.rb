class FileReader

  def read_simple(filename)
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
  
  def read_complex(filename)
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