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

  # @return [Symbol]
  def handle_console_input
    handled = nil
    re = /^\d+$/
    loop do
      input = gets.chomp
      unless re.match?(input)
        @error_message = "String must follow this regexp filter: #{re}"
        yield(nil)
        next
      end
      unless (handled = input.to_i).between?(1, @actions.length)
        @error_message = "Number must be between 1 and #{@actions.length}"
        yield(nil)
        next
      end
      break
    end
    @actions[handled.to_i - 1].name
  end
end
