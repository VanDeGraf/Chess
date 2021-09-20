class SaveLoadScreen < Screen
  def initialize(type, game: nil)
    super(HEADERS[type], input: ScreenDataInput.new(INPUT_DESCRIPTIONS[type], filters: [
                                                      InputFilter.new(/^[a-zA-Z \d_]+$/, handler: proc { |match_data|
                                                        filename = match_data.to_s
                                                        if @type == :load && !File.exist?(Game.full_name_of_save_file(filename))
                                                          InputFilter.error_result('Save file with this name not found!')
                                                        elsif @type == :import && !File.exist?(Game.full_name_of_export_file(filename))
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
      filename = @input.handle_console_input { |_| draw }
      case @type
      when :save
        filename = Game.full_name_of_save_file(filename)
        if File.exist?(filename) && !AcceptRequestScreen.show_and_read(
          'File with this name already exists, do you want rewrite it?'
        )
          draw
          next
        end

        @game.save(filename)
        MessageScreen.show("Game saved successfully to #{filename}")
        return @game
      when :load
        filename = Game.full_name_of_save_file(filename)
        return Game.load(filename)
      when :export
        filename = Game.full_name_of_export_file(filename)
        if File.exist?(filename) && !AcceptRequestScreen.show_and_read(
          'File with this name already exists, do you want rewrite it?' \
            '(Export save one game to one file only!)'
        )
          draw
          next
        end

        @game.export(filename)
        MessageScreen.show("Game saved successfully as PGN formatted to #{filename}")
        return @game
      when :import
        filename = Game.full_name_of_export_file(filename)
        saves_strings = Game.split_pgn_to_saves(filename)
        return Game.import(saves_strings[:saves].first) if saves_strings[:saves].length == 1

        choice = MultipleChoiceRequestScreen.show_and_read(
          saves_strings[:descriptions],
          "In this PGN file founded more then one game save!\n" \
            'Here each: [{Event}] {White Player Name} vs {Black Player Name}'
        )
        return Game.import(saves_strings[:saves][choice])
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
