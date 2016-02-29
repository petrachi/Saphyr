class Saphyr::VM::Driver
  attr_accessor :object, :parser, :source_code

  def initialize source_code
    @source_code = source_code

    @parser = Saphyr::VM::Parser.new source_code
    @object = Saphyr::Core::Object.new
  end

  def process
    parser.parse
    Saphyr::VM::Compiler.new(object, parser.root).compile
  end
end
