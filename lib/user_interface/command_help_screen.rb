class CommandHelpScreen < MessageScreen
  HELP_FILE = File.expand_path('help.txt', __dir__).freeze
  TEXT = File.read(HELP_FILE)

  def initialize
    super(TEXT)
    @header = 'Commands'
  end

  def self.show
    instance = new
    instance.draw
    gets
    nil
  end
end
