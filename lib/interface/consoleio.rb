class ConsoleIO < InterfaceIO
  def readline
    gets.chomp
  end

  def write(string)
    print(string)
  end

  def writeline(string)
    puts(string)
  end
end
