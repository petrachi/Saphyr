class Saphyr::VM::Compiler
  KEYWORDS = {
    "extend" => "dup_locals",
    "methods" => "locals",
    "print" => "print",
    "self" => "__itself__"
  }

  SYMBOL_TABLE = {
    "==" => "equal",
    "+" => "add"
  }

  attr_accessor :binding, :object, :root

  def initialize object, binding, root
    @object = object
    @binding = binding
    @root = root
  end

  def compile
    root.children.map do |node|
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

  # def subtree children
  #   subtree = Saphyr::VM::Node.root
  #   Array(children).each do |child_node|
  #     subtree.add_node child_node
  #   end
  #   subtree
  # end

  def compile_symbol node
    case node.token.content
    when "="
      # p " compile symbol ="

      method_name = node.children[0].token.content
      method_parameters = node.children[0].children.map(&:token).map(&:content)
      method_ast = Saphyr::VM::Node.subtree node.children[1..-1]

      # add args
      object.define_method method_name, method_parameters, method_ast

    when "."
      # p " compile symbol ."
      subtree_object = compile_node node.children[0] # @object.exec_method node.children.shift.token.content
      subtree_ast = Saphyr::VM::Node.subtree node.children[1..-1]

      # p " warning: new subtree with #{subtree_object}"
      Saphyr::VM::Compiler.new(subtree_object, binding, subtree_ast).compile



      # @object.exec(node.children[0].token.content, []).send(SYMBOL_TABLE[node.token.content], compile_node(node.children[1]))
    when "==", "+"
      # p " compile symbol other"

      # I can't do these cases while methods don't accepts arguments

      # Here, I must re-create an "regular" AST
      # from
      # symbol[child1, child2]
      # to
      # .[child1, symbol_to_identifier[child2]]
      # then, compile it
      #
      # It means that I must be able to indiferently execute ruby or saphyr written methods
      # So the 'add' method of string, for example, must be something that trigger execution when calling 'something.call self, parameters'
      # I suggest using Procs




      # ???
    end
  end

  def compile_identifier node
    case node.token.content
    # when "Object"
    #   # p " compile identifier Object"
    #
    #   Saphyr::Core::Object
    when *KEYWORDS.keys
      # p "compile identifier methods or print"

      # add args
      # if we can transform ruby-written methods into procs stored in @locals, we will no longer need thoses
      parameters = node.children.map do |child|
        Saphyr::VM::Compiler.new(binding, binding, Saphyr::VM::Node.subtree(child)).compile
      end
      object.send KEYWORDS[node.token.content], *parameters

    else
      local_name = node.token.content

      unless object.find_local local_name
        object.define_local local_name
      end

      local = object.find_local local_name
#p "l #{local.class}"
      case local
      when Saphyr::Core::Method
#p "meth"

        # parameters = node.children.map &method("compile_node")
        parameters = node.children.map do |child|
          Saphyr::VM::Compiler.new(binding, binding, Saphyr::VM::Node.subtree(child)).compile
        end

        local.call object, parameters
      when Saphyr::Core::Object
#p "obj"
        local

      end
      # p " compile identifier other"

      # here, parameters are searched whithin the 'object', but I must search them in the current context/binding



      # object.exec_local local_name, parameters
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
