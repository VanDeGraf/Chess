class SaveSerializer < Serializer
  SAVE_DIR = File.expand_path('../saves', __dir__).freeze

  def convert_to_string(game)
    YAML.dump(game)
  end

  def convert_from_string(data)
    game = YAML.safe_load(data, permitted_classes: Game::YAML_LOAD_PERMITTED_CLASSES, aliases: true)
    if game.nil?
      StandardError.new('Empty safe load result!')
    else
      game
    end
  rescue Psych::Exception => e
    StandardError.new(e.message)
  end

  def filepath(filename)
    "#{super}.yaml"
  end

  def file_directory
    SAVE_DIR
  end
end
