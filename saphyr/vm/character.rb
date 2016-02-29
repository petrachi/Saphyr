class Saphyr::VM::Character
  attr_accessor :column, :content, :index, :line

  def initialize content, index, line, column
    @content = content
    @index = index
    @line = line
    @column = column
  end

  def inspect
    "#{ content } at #{ index }[#{ line }, #{ column }]"
  end
end
