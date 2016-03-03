class Saphyr::Core::Method < Saphyr::Core::Object
  # Does this class should inherit of Object ?
  # That way it can have locals (wich can act as parameters)
  # But does it means to declare a method of a method ?

  attr_accessor :ast, :name, :parameters

  def initialize name, parameters, ast
    super()
    @name = name
    @parameters = parameters
    @ast = ast

    @owner = nil
  end

  def __itself__
    @owner
  end

  def call object, parameters
    # p "exec method ''#{name}'' for #{self}"
    # p "ast will be compiled #{ast.inspect}"

    # execute method
    # means to compile AST within this object biding
    @owner = object

    h = Hash[*[self.parameters, parameters].transpose.flatten]
    #p "calling #{name}(#{h})"

    #p "locals #{locals}"
    locals.merge! Hash[*[self.parameters, parameters].transpose.flatten]
    #p "locals #{locals}"


    # self.parameters.each do |parameter_name|
    #   locals[parameter_name] =
    # end

    Saphyr::VM::Compiler.new(self, self, ast).compile
  end

  def print
    ::Kernel.print sprint
  end

  def sprint
    "an Method"
    # should look like #<[object class name]#[object id]>
  end

end
