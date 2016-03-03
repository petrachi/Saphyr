class Saphyr::VM::Parser
  attr_accessor :lexer, :parsed, :root

  def self.parse_tokens tokens
    lexer = Saphyr::VM::Lexer.new ''
    lexer.tokens = tokens
    lexer.tokenized = true

    parser = Saphyr::VM::Parser.new ''
    parser.lexer = lexer
    parser.parse
    parser.root
  end

  def initialize source_code
    @lexer = Saphyr::VM::Lexer.new source_code

    @root = Saphyr::VM::Node.root
    @parsed = false
  end

  def parse
    parsed and return
    lexer.tokenize

    begin
      parse_token root
    end while lexer.peek

    self.parsed = true
  end

  def parse_token parent_node
    token = lexer.get

    case token.type
    when 'SYMBOL'
      parse_symbol parent_node, token
    when 'IDENTIFIER'
      parse_identifier parent_node, token
    when 'NUMBER'
      parse_number parent_node, token
    when 'STRING'
      parse_string parent_node, token
    end
  end

  def parse_symbol parent_node, token
    case token.content
    when "\n"
      # stop
    when "("
      begin
        tokens = []

        begin
          tokens << lexer.get
        end while ![",", ")"].include? lexer.current.content

        parent_node.last_child.merge Saphyr::VM::Parser.parse_tokens(tokens)

      end while lexer.current.content != ")" && lexer.peek

    when ")"
      # stop
    when ','
      # stop
    when '='
      node = parent_node.last_child.swap token



      stop_symbol = case lexer.peek.content
      when "\n"
        ";"
      else
        "\n"
      end

# p node
# p stop_symbol


      begin
        parse_token node
      #  p "parsing #{lexer.current.inspect}"
      end while lexer.current.content != stop_symbol && lexer.peek
      # p "found stop symbol"
    when "."
      node = parent_node.last_child.swap token

      begin
        parse_token node
      end while ![";", "\n"].include?(lexer.current.content) && lexer.peek
    end
  end

  def parse_identifier parent_node, token
    parent_node.add token
  end

  def parse_number parent_node, token
    parent_node.add token
  end

  def parse_string parent_node, token
    parent_node.add token
  end
end
