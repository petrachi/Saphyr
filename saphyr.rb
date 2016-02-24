module Saphyr
  module Core
    require './saphyr/core/binding.rb'
    require './saphyr/core/kernel.rb'
    require './saphyr/core/number.rb'
    require './saphyr/core/string.rb'
  end

  module VM
    require './saphyr/vm/character.rb'
    require './saphyr/vm/scanner.rb'

    require './saphyr/vm/token.rb'
    require './saphyr/vm/lexer.rb'

    require './saphyr/vm/node.rb'
    require './saphyr/vm/parser.rb'

    require './saphyr/vm/compiler.rb'

    #######################################
    # x = Lexer.new(File.open("nnx.sy").read)
    # x.tokenize
    # p *x.instance_variable_get("@tokens")
    #######################################
    # x = Parser.new(File.open("nnx.sy").read)
    # x.parse
    # p *x.instance_variable_get("@root")
    #####################################
    # p "#"*45
    # x = Compiler.new(File.open("nnx.sy").read)
    # x.compile
    #####################################
  end

  def self.[] file_path
    Saphyr::VM::Compiler.new(File.open(file_path).read).compile
  end



  ################################
  #
  # code
  # a.b.c
  #
  # see identifier "a" -> create node "a"
  # a
  #
  # see symbol "." -> create node "." and put previous node as child, and look at next token, see identifier "b", put it as child
  # .
  #   a
  #   b
  #
  # see symbol "." -> create node "." and put previous node as child, and look at next token, see identifier "c", put it as child
  # .
  #   .
  #     a
  #     b
  #   c
  #
  # compile (we assume this method #apply(object, method))
  # apply(apply(a, b), c)
  #
  ############################
  #
  # alpha = 12
  # beta = 2
  # result = alpha + beta
  # print(result)
  #
  # =
  #   alpha
  #   12
  # =
  #   beta
  #   2
  # =
  #   result
  #   +
  #     alpha
  #     beta
  # print
  #   result
  #
  # assign("alpha", 12)
  # assign("beta", 2)
  # assign("result", exec("alpha").add(exec("beta")))
  # print(exec("result"))
  #
  ##########################
  #
  # CODE
  #
  # a
  #
  # AST
  #
  # .
  #   a
  #
  # COMPILE
  #
  # exec("a")
  #
  ##########################

end
