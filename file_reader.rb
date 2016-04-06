class FileReader

  def read_from_file(filename)
    if File.exist?(filename)
      f = File.new(filename,"r:UTF-8")
      lines = f.readlines
      f.close
      return lines
    else
      abort "Файл #{filename} не найден"
    end

  end
end