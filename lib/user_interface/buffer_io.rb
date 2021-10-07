class BufferIO < UserInterfaceIO
  attr_reader :input_buffer, :output_buffer

  def initialize
    super
    @input_buffer = StringIO.new('', 'a+')
    @output_buffer = StringIO.new('', 'a+')
  end

  def readline
    @input_buffer.gets.chomp
  end

  def write(string)
    @output_buffer.write(string)
  end

  def writeline(string)
    @output_buffer.write("#{string}\n")
  end

  def clear
    @input_buffer.truncate(0)
    @input_buffer.rewind
    @output_buffer.truncate(0)
    @output_buffer.rewind
  end
end
