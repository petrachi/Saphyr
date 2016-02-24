class Saphyr::Core::String
  def initialize intern
    @intern = intern
  end

  def sprint
    @intern
  end
end
