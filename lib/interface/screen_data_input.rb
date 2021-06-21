require_relative 'menu_action'

class ScreenDataInput < ScreenInput
  # @param description_message [String]
  # @param filter [Regexp]
  def initialize(description_message, filter: nil)
    super(description_message)
    # @type [Regexp]
    @filter = filter
  end

  def handle_console_input
    handled = nil
    loop do
      input = gets.chomp
      if !@filter.nil? && !@filter.match?(input)
        @error_message = "String must follow this regexp filter: #{@filter}"
        yield(nil)
        next
      end
      if (handled = yield(input)).nil?
        yield(nil)
        next
      end
      break
    end
    handled
  end
end
