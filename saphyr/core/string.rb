class Saphyr::Core::String < Saphyr::Core::Object
  attr_accessor :intern

  def initialize intern
    super()
    @intern = intern
  end

  def exec_method name
    # p "ruby method : exec method ''#{name}'' for #{self}"
    send name
  end

  def sprint
    intern
  end
end
