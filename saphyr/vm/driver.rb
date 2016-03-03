class Saphyr::VM::Driver
  attr_accessor :object, :parser, :source_code

  def initialize source_code
    @source_code = source_code

    @parser = Saphyr::VM::Parser.new source_code
    @object = Saphyr::Core::Object.new
  end

  def read
    parser.parse
    Saphyr::VM::Compiler.new(object, object, parser.root).compile
  end
end
