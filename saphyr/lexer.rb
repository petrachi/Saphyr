module Saphyr
  class Lexer
    IDENTIFIER_STARTCHARS = ('a'..'z').to_a + ('A'..'Z').to_a
    IDENTIFIER_CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ["_"]

    NUMBER_STARTCHARS = ('0'..'9').to_a
    NUMBER_CHARS = ('0'..'9').to_a + ["."]

    STRING_STARTCHARS = ["'", '"']

    ONE_CHAR_SYMBOLS = ["=", "+", ".", "(", ",", ")", "\n"]
    TWO_CHAR_SYMBOLS = ["=="]
    WHITESPACE_CHARS  = [" ", "\t"]

    def initialize source_code
      @source_code = source_code
      @tokens = []

      @scanner = Scanner.new source_code
      @index = -1
    end

    def tokenize
      @scanner.scan
      begin
        char = @scanner.get

        case char.content
        when *WHITESPACE_CHARS
          next
        when *NUMBER_STARTCHARS
          tokenize_number char
        when *STRING_STARTCHARS
          tokenize_string char
        when *IDENTIFIER_STARTCHARS
          tokenize_identifier char
        else
          if @scanner.peek && TWO_CHAR_SYMBOLS.include?(char.content + @scanner.peek.content)
            tokenize_two_char_symbol char
          elsif ONE_CHAR_SYMBOLS.include? char.content
            tokenize_one_char_symbol char
          end
        end
      end while @scanner.peek
    end

    def tokenize_number char
      token_chars = [char]
      while NUMBER_CHARS.include? @scanner.peek.content
        token_chars << @scanner.get
      end

      @tokens << Token.new('NUMBER', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
    end

    def tokenize_string char
      token_chars = []
      while @scanner.get.content != char.content
        token_chars << @scanner.current
      end

      @tokens << Token.new('STRING', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
    end

    def tokenize_identifier char
      token_chars = [char]
      while IDENTIFIER_CHARS.include? @scanner.peek.content
        token_chars << @scanner.get
      end

      @tokens << Token.new('IDENTIFIER', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
    end

    def tokenize_two_char_symbol char
      token_chars = [char, @scanner.get]
      @tokens << Token.new('SYMBOL', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
    end

    def tokenize_one_char_symbol char
      @tokens << Token.new('SYMBOL', char.content, char.line, char.column)
    end

    def get
      @index += 1
      @tokens[@index]
    end

    def current
      @tokens[@index]
    end

    def peek
      @tokens[@index + 1]
    end
  end
end
