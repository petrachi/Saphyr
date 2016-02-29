class Saphyr::VM::Compiler
  SYMBOL_TABLE = {
    "=" => "assign",
    "==" => "equal",
    "+" => "add"
  }

  def initialize object, root
    @object = object
    @root = root
  end

  def compile
    @root.children.map do |node|
      compile_node node
    end.last
  end

  def compile_node node


    # p "-> compile node " + node.token.inspect

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

  def subtree children
    subtree = Saphyr::VM::Node.root
    children.each do |child_node|
      subtree.add_node child_node
    end
    subtree
  end

  def compile_symbol node
    case node.token.content
    when "="
      # p " compile symbol ="

      method_name = node.children[0].token.content
      method_ast = subtree node.children[1..-1]

      @object.define_method method_name, method_ast
    when "."
      # p " compile symbol ."

      subtree_object = compile_node node.children[0] # @object.exec_method node.children.shift.token.content
      subtree_ast = subtree node.children[1..-1]

      # p " warning: new subtree"
      self.class.new(subtree_object, subtree_ast).compile



      # @object.exec(node.children[0].token.content, []).send(SYMBOL_TABLE[node.token.content], compile_node(node.children[1]))
    when "==", "+"
      # p " compile symbol other"

      # I can't do these cases while methods don't accepts arguments

      # ???
    end
  end

  def compile_identifier node
    case node.token.content
    when "Object"
      # p " compile identifier Object"

      Saphyr::Core::Object
    when "self"
      @object
    when "methods", "print"
      # p "compile identifier methods or print"

      @object.send(node.token.content)
    else
      # p " compile identifier other"

      @object.exec_method node.token.content
    end

    # args = node.children.map &method("compile_node")
    # @object.exec(node.token.content, args)
  end

  def compile_number node
    # p " compile number"

    Saphyr::Core::Number.new node.token.content
  end

  def compile_string node
    # p " compile string"

    Saphyr::Core::String.new node.token.content
  end
end
