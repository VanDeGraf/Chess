class Serializer
  # @param game [Game]
  # @param filename [String]
  # @return [StandardError, nil]
  def serialize(game, filename)
    Dir.mkdir(file_directory) unless Dir.exist?(file_directory)
    path = filepath(filename)
    File.write(path, convert_to_string(game))
  rescue StandardError => e
    e
  else
    nil
  end

  # @param game [Game]
  # @return [String]
  def convert_to_string(game) end

  # @param filename [String]
  # @return [Array<Game>,Game,StandardError]
  def deserialize(filename)
    path = filepath(filename)
    return nil unless File.exist?(path)

    convert_from_string(File.read(path))
  rescue StandardError => e
    e
  end

  # @param data [String]
  # @return [Array<Game>, Game, StandardError]
  def convert_from_string(data) end

  # @param filename [String]
  # @return [String]
  def filepath(filename)
    "#{file_directory}/#{filename}"
  end

  # @return [String]
  def file_directory; end
end
