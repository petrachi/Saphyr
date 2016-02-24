module Saphyr
  class Scanner
    def initialize source_code
      @source_code = source_code
      @characters = []

      @index = -1
    end

    def scan
      index_number = 0
      line_number = 0
      column_number = 0

      @source_code.each_line.map do |line|
        line_number += 1
        column_number = 0

        line.each_char.map do |char|
          index_number += 1
          column_number += 1

          @characters << Character.new(char, index_number, line_number, column_number)
        end
      end
    end

    def get
      @index += 1
      @characters[@index]
    end

    def current
      @characters[@index]
    end

    def peek
      @characters[@index + 1]
    end
  end
end
