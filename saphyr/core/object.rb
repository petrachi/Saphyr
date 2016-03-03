class Saphyr::Core::Object
  attr_accessor :locals

  def initialize
    @locals = {}
    @locals.define_singleton_method("print", ->{ ::Kernel.print keys })
  end

  def __itself__
    self
  end

  def define_method name, parameters, ast
    # p "defining method ''#{name}'' for #{self}"
    # p "ast look : #{ ast.inspect}"

    locals[name] = Saphyr::Core::Method.new(name, parameters, ast)



    #p "defining method ''#{name}'' -> #{locals[name]} for #{self}"
    locals[name]
  end

  def define_local name
    locals[name] = Saphyr::Core::Object.new



    #p "declaring a new object '#{name}' -> #{locals[name]} within #{self}"
    locals[name]
  end

  def find_local name
    locals[name]
  end

  def dup_locals locals
    self.locals.merge! locals
  end

  # def exec_local name, parameters
  #
  #   # p "calling '#{name}'"
  #
  #   locals[name].call self, parameters
  # end

  # def self.exec_method name
  #   # p "ruby method : exec method ''#{name}'' for #{self}"
  #   send name
  # end

  def call *_
    self
  end

  def print
    ::Kernel.print sprint
  end

  def sprint
    "an Object"
    # should look like #<[object class name]#[object id]>
  end
end
