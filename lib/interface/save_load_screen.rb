class SaveLoadScreen < Screen
  def initialize(type, game: nil)
    header = type == :save ? 'Save Current Game' : 'Load Game From File'
    input_desc = if type == :load
                   'Enter the name of existed save (without file extension)'
                 else
                   'Enter the name of new save file (without file extension)'
                 end
    super(header, input: ScreenDataInput.new(input_desc, filter: /^[a-zA-Z \d]+$/))
    @type = type
    @game = game
  end

  # @param type [Symbol] :save or :load
  # @param game [Game] not nil for type == :save
  # @return [Game] loaded or saved instance
  def self.show_and_read(type, game: nil)
    instance = new(type, game: game)
    instance.draw
    instance.handle_input
  end

  def handle_input
    loop do
      save_name = @input.handle_console_input do |save_name|
        if save_name.nil?
          draw
          next
        end
        if @type == :load && !File.exist?(Game.full_name_of_save_file(save_name))
          @input.error_message = 'Save file with this name not found!'
          next
        end
        save_name
      end
      filename = Game.full_name_of_save_file(save_name)
      if @type == :save
        if File.exist?(filename) && !AcceptRequestScreen.show_and_read(
          'File with this name already exists, do you want rewrite it?'
        )
          draw
          next
        end

        @game.save(save_name)
        MessageScreen.show("Game saved successfully to #{filename}")
        return @game
      else
        return Game.load(save_name)
      end
    end
  end
end
