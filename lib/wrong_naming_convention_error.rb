class WrongNamingConventionError < StandardError
  def message
    @message || 'Please enter a valid name'
  end
end
