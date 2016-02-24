class Saphyr::VM::Token
  attr_accessor :type, :content, :line, :column

  def initialize type, content, line, column
    @type = type
    @content = content
    @line = line
    @column = column
  end

  def inspect
    "#{@type}: #{@content.inspect} at [#{@line}, #{@column}]"
  end
end
