require_relative 'menu_action'
require_relative 'input_filter'

class ScreenDataInput < ScreenInput
  # @param screen [Screen]
  # @param description_message [String]
  # @param filters [Array<InputFilter>]
  # @param default_errmsg [String]
  def initialize(screen, description_message, filters: [], default_errmsg: nil)
    super(screen, description_message)
    # @type [Array<InputFilter>]
    @filters = filters
    @default_errmsg = default_errmsg
  end

  def handle_console_input
    loop do
      @error_message = nil
      input = UserInterface.io.readline
      @filters.each do |filter|
        match_result = match_filter(filter, input)
        return match_result unless match_result.nil?
      end
      @error_message = @default_errmsg if @error_message.nil?
      @screen.draw
    end
  end

  def match_filter(filter, input)
    match_result = filter.match(input)
    return match_result unless match_result.is_a?(Hash) && match_result[:action] == :error

    @error_message = match_result[:error_message] unless match_result[:error_message].nil?
    nil
  end
end
