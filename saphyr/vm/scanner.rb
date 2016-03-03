class Saphyr::VM::Scanner
  attr_accessor :characters, :index, :scanned, :source_code

  def initialize source_code
    @source_code = source_code
    @characters = []

    @index = -1
    @scanned = false
  end

  def scan
    scanned and return

    index_number = 0
    line_number = 0
    column_number = 0

    source_code.each_line.map do |line|
      line_number += 1
      column_number = 0

      line.each_char.map do |char|
        index_number += 1
        column_number += 1

        characters << Saphyr::VM::Character.new(char, index_number, line_number, column_number)
      end
    end

    self.scanned = true
  end

  def get
    characters[self.index += 1]
  end

  def current
    characters[index]
  end

  def peek
    characters[index + 1]
  end
end
