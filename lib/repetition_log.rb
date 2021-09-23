class RepetitionLog
  def initialize
    # @type [Hash<String, Integer>]
    @repetition_hash = {}
  end

  # @param movement [Movement]
  # @param board [Board]
  def add!(movement, board)
    return if movement.nil?

    hash = repetition_hash_summary(movement.figure.color, board)
    if @repetition_hash.key?(hash)
      @repetition_hash[hash] += 1
    else
      @repetition_hash[hash] = 1
    end
  end

  def clear!
    @repetition_hash = {}
  end

  # @param repetition_count [Integer]
  def n_fold_repetition?(repetition_count)
    @repetition_hash.any? { |_hash, count| count >= repetition_count }
  end

  def clone
    new_log = RepetitionLog.new
    new_log.instance_variable_set(:@repetition_hash, @repetition_hash.clone)
    new_log
  end

  private

  # @param color [Symbol]
  # @param board [Board]
  def repetition_hash_summary(color, board)
    hash = color == :white ? 'w' : 'b'
    hash += MovementGenerator.castling(board, color).length.to_s
    hash += board.state.en_passant?(color) ? '1' : '0'
    board.each_figure do |figure|
      hash += figure_hash(figure)
    end
    hash
  end

  # @param figure [Figure]
  # @return [String]
  def figure_hash(figure)
    if figure.nil?
      '-'
    elsif figure.figure == :knight
      'n'
    else
      figure.figure[0]
    end
  end
end
