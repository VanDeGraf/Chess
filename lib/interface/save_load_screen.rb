class SaveLoadScreen < Screen
  def initialize(type, game: nil)
    super(HEADERS[type],
          input: ScreenDataInput.new(INPUT_DESCRIPTIONS[type],
                                     filters: [
                                       InputFilter.new(/^[a-zA-Z \d_]+$/, handler: proc { |match_data|
                                         filename = match_data.to_s
                                         if @type == :load && !File.exist?(SaveSerializer.new.filepath(filename))
                                           InputFilter.error_result('Save file with this name not found!')
                                         elsif @type == :import && !File.exist?(PGNSerializer.new.filepath(filename))
                                           InputFilter.error_result('PGN formatted save file with this name not found!')
                                         else
                                           filename
                                         end
                                       })
                                     ]))
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
      filename = @input.handle_console_input(-> { draw })
      case @type
      when :save
        ss = SaveSerializer.new
        if File.exist?(ss.filepath(filename)) && !AcceptRequestScreen.show_and_read(
          'File with this name already exists, do you want rewrite it?'
        )
          draw
          next
        end
        ss.serialize(@game, filename)
        MessageScreen.show("Game saved successfully to #{ss.filepath(filename)}")
        return @game
      when :load
        return SaveSerializer.new.deserialize(filename)
      when :export
        pgns = PGNSerializer.new
        if File.exist?(pgns.filepath(filename)) && !AcceptRequestScreen.show_and_read(
          'File with this name already exists, do you want rewrite it?' \
            '(Export save one game to one file only!)'
        )
          draw
          next
        end
        pgns.serialize(@game, filename)
        MessageScreen.show("Game saved successfully as PGN formatted to #{pgns.filepath(filename)}")
        return @game
      when :import
        games = PGNSerializer.new.deserialize(filename)
        return games unless games.is_a?(Array)

        descriptions = []
        games.each { |game| descriptions << game.description }
        choice = MultipleChoiceRequestScreen.show_and_read(
          descriptions,
          "In this PGN file founded more then one game save!\n" \
            'Here each: {White Player Name} vs {Black Player Name} : {Status}'
        )
        return games[choice]
      end
    end
  end

  HEADERS = {
    save: 'Save Current Game',
    load: 'Load Game From File',
    export: 'Export Current Game',
    import: 'Import Game From File'
  }.freeze

  INPUT_DESCRIPTIONS = {
    save: 'Enter the name of new save file (without file extension)',
    load: 'Enter the name of existed save (without file extension)',
    export: 'Enter the name of new PGN formatted save file (without file extension)',
    import: 'Enter the name of existed PGN formatted save file (without file extension)'
  }.freeze
end
