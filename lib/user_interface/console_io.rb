class ConsoleIO < UserInterfaceIO
  def readline
    gets.chomp
  end

  def write(string)
    print(string)
  end

  def writeline(string)
    puts(string)
  end

  def clear
    system('clear') || system('cls')
  end
end
