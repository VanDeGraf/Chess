require_relative 'user_interface'
require_relative 'screen_input'
require_relative 'screen_data_input'
require_relative 'screen_menu_input'

class Screen
  # @param header [String]
  # @param input [ScreenInput]
  def initialize(header, input: nil)
    @header = header
    # @type [ScreenInput]
    @input = input
  end

  def draw
    UserInterface.clear_console
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.io.write @input.draw unless @input.nil?
  end
end
