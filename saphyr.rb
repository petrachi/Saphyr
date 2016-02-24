module Saphyr
  require './saphyr/character.rb'
  require './saphyr/scanner.rb'

  require './saphyr/token.rb'
  require './saphyr/lexer.rb'

  require './saphyr/node.rb'
  require './saphyr/parser.rb'


  #######################################
  x = Lexer.new(File.open("nnx.sy").read)
  x.tokenize
  p *x.instance_variable_get("@tokens")
  #######################################
  x = Parser.new(File.open("nnx.sy").read)
  x.parse
  p *x.instance_variable_get("@root")
  #####################################


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
  # print result
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
  # assign("result", add(exec("alpha"), exec("beta")))
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
