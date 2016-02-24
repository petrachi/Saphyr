class Saphyr::Core::Number
  attr_accessor :intern

  def initialize intern
    @intern = intern.to_i
  end

  def add number
    Saphyr::Core::Number.new(@intern + number.intern)
  end

  def sprint
    @intern
  end
end
