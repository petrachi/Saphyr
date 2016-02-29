class Saphyr::Core::Number < Saphyr::Core::Object
  attr_accessor :intern

  def initialize intern
    super()
    @intern = intern.to_i
  end

  def exec_method name
    # p "ruby method : exec method ''#{name}'' for #{self}"
    send name
  end


  def add number
    self.intern += number.intern
  end

  def to_s
    Saphyr::Core::String.new intern.to_s
  end

  def sprint
    intern
  end
end
