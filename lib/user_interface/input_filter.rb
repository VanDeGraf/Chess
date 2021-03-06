class InputFilter
  # @param regexp [Regexp]
  # @param handler [Proc]
  def initialize(regexp, handler: nil)
    @regexp = regexp
    @handler = handler
  end

  # @param error_message [String]
  # @return [Hash]
  def self.error_result(error_message = nil)
    if error_message.nil?
      { action: :error }
    else
      { action: :error,
        error_message: error_message }
    end
  end

  # @param str [String]
  # @return [Hash]
  def match(str)
    match_data = @regexp.match(str)
    return InputFilter.error_result if match_data.nil? || match_data.size.zero?

    if @handler.nil?
      match_data.to_s
    else
      @handler.call(match_data)
    end
  end
end
