class Saphyr::Core::Method
  # Does this class should inherit of Object ?
  # That way it can have locals (wich can act as parameters)
  # But does it means to declare a method of a method ?

  attr_accessor :name, :ast

  def initialize name, ast
    @name = name
    @ast = ast
  end

  def call object
    # p "exec method ''#{name}'' for #{self}"
    # p "ast will be compiled #{ast.inspect}"

    # execute method
    # means to compile AST within this object biding
    Saphyr::VM::Compiler.new(object, ast).compile
  end

  def print
    ::Kernel.print sprint
  end

  def sprint
    "an Method"
    # should look like #<[object class name]#[object id]>
  end

end
