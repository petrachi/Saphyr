module Saphyr
  class Character
    attr_accessor :content, :index, :line, :column

    def initialize content, index, line, column
      @content = content
      @index = index
      @line = line
      @column = column
    end

    def inspect
      "#{@content} at #{@index}[#{@line}, #{@column}]"
    end
  end
end
