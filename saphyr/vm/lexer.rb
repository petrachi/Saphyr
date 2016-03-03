class Saphyr::VM::Lexer
  IDENTIFIER_STARTCHARS = ('a'..'z').to_a + ('A'..'Z').to_a
  IDENTIFIER_CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ["_"]

  NUMBER_STARTCHARS = ('0'..'9').to_a
  NUMBER_CHARS = ('0'..'9').to_a

  STRING_STARTCHARS = ["'", '"']

  ONE_CHAR_SYMBOLS = ["=", "+", ".", "(", ",", ")", ";", "\n"]
  TWO_CHAR_SYMBOLS = ["=="]
  WHITESPACE_CHARS  = [" ", "\t"]

  COMMENT_CHARS = ["#"]

  attr_accessor :index, :scanner, :source_code, :tokenized, :tokens

  def initialize source_code
    @source_code = source_code
    @tokens = []

    @scanner = Saphyr::VM::Scanner.new source_code
    @index = -1
    @tokenized = false
  end

  def tokenize
    tokenized and return

    scanner.scan
    begin
      char = scanner.get

      case char.content
      when *COMMENT_CHARS
        begin
          scanner.get
        end while scanner.current.content != "\n"
      when *WHITESPACE_CHARS
        next
      when *NUMBER_STARTCHARS
        tokenize_number char
      when *STRING_STARTCHARS
        tokenize_string char
      when *IDENTIFIER_STARTCHARS
        tokenize_identifier char
      else
        if @scanner.peek && TWO_CHAR_SYMBOLS.include?(char.content + scanner.peek.content)
          tokenize_two_char_symbol char
        elsif ONE_CHAR_SYMBOLS.include? char.content
          tokenize_one_char_symbol char
        end
      end
    end while scanner.peek

    self.tokenized = true
  end

  def tokenize_number char
    token_chars = [char]
    while NUMBER_CHARS.include? scanner.peek.content
      token_chars << scanner.get
    end

    tokens << Saphyr::VM::Token.new('NUMBER', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
  end

  def tokenize_string char
    token_chars = []
    while scanner.get.content != char.content
      token_chars << scanner.current
    end

    token_content = token_chars.map(&:content).join
    token_content.gsub!('\n', "\n")

    tokens << Saphyr::VM::Token.new('STRING', token_content, token_chars[0].line, token_chars[0].column)
  end

  def tokenize_identifier char
    token_chars = [char]
    while IDENTIFIER_CHARS.include? scanner.peek.content
      token_chars << scanner.get
    end

    tokens << Saphyr::VM::Token.new('IDENTIFIER', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
  end

  def tokenize_two_char_symbol char
    token_chars = [char, scanner.get]
    tokens << Saphyr::VM::Token.new('SYMBOL', token_chars.map(&:content).join, token_chars[0].line, token_chars[0].column)
  end

  def tokenize_one_char_symbol char
    tokens << Saphyr::VM::Token.new('SYMBOL', char.content, char.line, char.column)
  end

  def get
    tokens[self.index += 1]
  end

  def current
    tokens[index]
  end

  def peek
    tokens[index + 1]
  end
end
