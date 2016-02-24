class Saphyr::VM::Parser
  attr_accessor :lexer, :root

  def initialize source_code
    @lexer = Saphyr::VM::Lexer.new source_code
    @root = Saphyr::VM::Node.new Saphyr::VM::Token.new('', '', 0, 0)
  end

  def parse
    @lexer.tokenize

    begin
      parse_token @root
    end while @lexer.peek
  end

  def parse_token parent_node
    token = @lexer.get

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
        parse_token parent_node.last_child
      end while @lexer.current.content != ")"

    when ")"
      # stop
    when ','
      # stop
    else
      node = parent_node.last_child.swap token

      begin
        parse_token node
      end while @lexer.current.content != "\n"
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
