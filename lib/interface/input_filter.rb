class InputFilter
  # @param regexp [Regexp]
  # @param handler [Proc]
  def initialize(regexp, handler: nil)
    @regexp = regexp
    @handler = handler
  end

  # @param str [String]
  # @return [Hash]
  def match(str)
    match_data = @regexp.match(str)
    return { action: :error } if match_data.nil? || match_data.size.zero?

    if @handler.nil?
      match_data.to_s
    else
      @handler.call(match_data)
    end
  end
end
