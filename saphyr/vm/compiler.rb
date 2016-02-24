class Saphyr::VM::Compiler
  SYMBOL_TABLE = {"=" => "assign", "+" => "add"}

  def initialize source_code
    @source_code = source_code

    @parser = Saphyr::VM::Parser.new source_code
    @binding = Saphyr::Core::Binding.new Saphyr::Core::Kernel.new
  end

  def compile
    @parser.parse

    @parser.root.children.each do |node|
      compile_node node
    end

    @binding.exec("newline", [])
  end

  def compile_node node
    case node.token.type
    when 'SYMBOL'
      compile_symbol node
    when 'IDENTIFIER'
      compile_identifier node
    when 'NUMBER'
      compile_number node
    when 'STRING'
      compile_string node
    end
  end

  def compile_symbol node


    case node.token.content
    when "="
      @binding.assign node.children[0].token.content, [], compile_node(node.children[1])

      #p "assign(#{node.children.first.token.content}, #{node.children.last.token.content})"
    else
      @binding.exec(node.children[0].token.content, []).send(SYMBOL_TABLE[node.token.content], compile_node(node.children[1]))


    #  p "add(#{node.children.first.token.content}, #{node.children.last.token.content})"
    end
  end

  def compile_identifier node
    args = node.children.map &method("compile_node")
    @binding.exec(node.token.content, args)

    #p "#{node.token.content}(#{node.children.map(&:token).map(&:content).join(",")})" # keyword case
  end

  def compile_number node
    Saphyr::Core::Number.new node.token.content
  end

  def compile_string node
    Saphyr::Core::String.new node.token.content
  end
end
