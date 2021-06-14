class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def turn_input_parse
    input = gets.chomp
    unless input.match?(%r{^([a-h][1-8] [a-h][1-8])|(/[a-z]+ ?(\S* ?)*)|(s \d+)$})
      return {
        action: :error,
        msg: "Can't understand input string!"
      }
    end
    case input[0]
    when '/'
      input = input[1..input.length - 1].split
      {
        action: :command,
        command: input.shift,
        arguments: input
      }
    when 's'
      {
        action: :special_move,
        move_index: input.split[1].to_i - 1
      }
    else
      input = input.split
      {
        action: :move,
        point_start: Coordinate.from_s(input[0]),
        point_end: Coordinate.from_s(input[1])
      }
    end
  end

  def self.name_input_parse
    input = gets.chomp
    unless input.match?(/^[a-zA-Z \.\']+$/)
      return {
        action: :error,
        msg: "Can't understand input string! Name must follow this RegExp mask: /^[a-zA-Z \\.\\']+$/"
      }
    end
    {
      action: :name,
      name: input
    }
  end

  def to_s
    "#{@name}(#{@color})"
  end
end
