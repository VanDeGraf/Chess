class ScreenMenuInput < ScreenInput
  # @param actions [Array<MenuAction>] - will draw in initialized order
  def initialize(actions = [])
    super('Enter the number of the action you would like to perform: ')
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

  # @param screen_draw_method [Proc]
  # @return [Symbol, Integer, String]
  def handle_console_input(screen_draw_method)
    input = nil
    loop do
      input = gets.chomp
      next unless regexp_verify?(input, screen_draw_method) &&
                  number_range_verify?(input, screen_draw_method)

      break
    end
    @actions[input.to_i - 1].name
  end

  def regexp_verify?(input, screen_draw_method)
    re = /^\d+$/
    return true if re.match?(input)

    @error_message = "String must follow this regexp filter: #{re}"
    screen_draw_method.call
    false
  end

  def number_range_verify?(input, screen_draw_method)
    return true if input.to_i.between?(1, @actions.length)

    @error_message = "Number must be between 1 and #{@actions.length}"
    screen_draw_method.call
    false
  end
end
