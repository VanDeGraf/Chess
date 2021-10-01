class ScreenMenuInput < ScreenInput
  # @param screen [Screen]
  # @param actions [Array<MenuAction>] - will draw in initialized order
  def initialize(screen, actions = [])
    super(screen, 'Enter the number of the action you would like to perform: ')
    # @type [Array<MenuAction>]
    @actions = actions
  end

  # @return [String]
  def draw
    buffer = StringIO.new
    @actions.each_with_index { |menu_item, index| buffer << menu_item.draw(index) }
    buffer << super
    buffer.string
  end

  # @return [Symbol, Integer]
  def handle_console_input
    input = nil
    loop do
      input = gets.chomp
      next unless regexp_verify?(input) &&
                  number_range_verify?(input)

      break
    end
    @actions[input.to_i - 1].name
  end

  def regexp_verify?(input)
    re = /^\d+$/
    return true if re.match?(input)

    @error_message = "String must follow this regexp filter: #{re}"
    @screen.draw
    false
  end

  def number_range_verify?(input)
    return true if input.to_i.between?(1, @actions.length)

    @error_message = "Number must be between 1 and #{@actions.length}"
    @screen.draw
    false
  end
end
