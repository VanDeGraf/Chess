class SaveLoadScreen < Screen
  def initialize(type, game: nil)
    super(HEADERS[type],
          input: ScreenDataInput.new(self,
                                     INPUT_DESCRIPTIONS[type],
                                     filters: init_data_input_filters))
    @type = type
    @game = game
  end

  def init_data_input_filters
    [InputFilter.new(/^[a-zA-Z \d_]+$/, handler: proc { |match_data|
      filename = match_data.to_s
      if @type == :load && !File.exist?(SaveSerializer.new.filepath(filename))
        InputFilter.error_result('Save file with this name not found!')
      elsif @type == :import && !File.exist?(PGNSerializer.new.filepath(filename))
        InputFilter.error_result('PGN formatted save file with this name not found!')
      else
        filename
      end
    })]
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
    command_result = nil
    while command_result.nil?
      filename = @input.handle_console_input
      command_result = perform_command(filename)
    end
    command_result
  end

  def perform_command(filename)
    case @type
    when :save
      handle_save_command(filename)
    when :load
      SaveSerializer.new.deserialize(filename)
    when :export
      handle_export_command(filename)
    when :import
      handle_export_command(filename)
    end
  end

  def handle_save_command(filename)
    ss = SaveSerializer.new
    if File.exist?(ss.filepath(filename)) && !AcceptRequestScreen.show_and_read(
      'File with this name already exists, do you want rewrite it?'
    )
      draw
      return nil
    end
    ss.serialize(@game, filename)
    MessageScreen.show("Game saved successfully to #{ss.filepath(filename)}")
    @game
  end

  def handle_export_command(filename)
    pgns = PGNSerializer.new
    if File.exist?(pgns.filepath(filename)) && !AcceptRequestScreen.show_and_read(
      'File with this name already exists, do you want rewrite it?'
    )
      draw
      return nil
    end
    pgns.serialize(@game, filename)
    MessageScreen.show("Game saved successfully as PGN formatted to #{pgns.filepath(filename)}")
    @game
  end

  def handle_import_command(filename)
    games = PGNSerializer.new.deserialize(filename)
    return games unless games.is_a?(Array)

    descriptions = []
    games.each { |game| descriptions << game.description }
    choice = MultipleChoiceRequestScreen.show_and_read(
      descriptions,
      "In this PGN file founded more then one game save!\n" \
            'Here each: {White Player Name} vs {Black Player Name} : {Status}'
    )
    games[choice]
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
