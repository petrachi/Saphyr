module Saphyr
  class Parser
    def initialize source_code
      @lexer = Lexer.new source_code
      @root = Node.new nil
    end

    def parse
      @lexer.tokenize
      begin
        token = @lexer.get

        case token.type
        when 'IDENTIFIER'
          parse_identifier @root, token
        when 'NUMBER'
          parse_number @root, token
        when 'STRING'
          parse_string @root, token
        else
          raise "Improper syntax near #{token.inspect}"
        end

      end while @lexer.peek
    end

    def parse_identifier parent_node, token
      case @lexer.peek.type
      when 'SYMBOL'
        parse_symbol parent_node, token
      else
        raise "Improper syntax near #{@lexer.peek.inspect}"
      end
    end

    def parse_symbol parent_node, token
      case @lexer.peek.content
      when "\n"
        # stop
      else
        node = parent_node.add @lexer.get
        node.add token

        begin
          token = @lexer.get

          case token.type
          when 'IDENTIFIER'
            parse_identifier node, token
          when 'NUMBER'
            parse_number node, token
          when 'STRING'
            parse_string node, token
          when 'SYMBOL'
            parse_symbol node, token
          else
            raise "Improper syntax near #{token.inspect}"
          end

        end while token.content != "\n"
      end
    end

    def parse_number parent_node, token
      parent_node.add token
    end

    def parse_string parent_node, token
      parent_node.add token
    end
  end
end
