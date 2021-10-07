require_relative 'interface'
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
    Interface.clear_console
    Interface.io.write "\t#{@header}\n"
    Interface.io.write @input.draw unless @input.nil?
  end
end
