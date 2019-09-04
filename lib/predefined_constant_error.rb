class PredefinedConstantError < StandardError
  def message
    @message || 'Class name is already in use, please provide new name'
  end
end
