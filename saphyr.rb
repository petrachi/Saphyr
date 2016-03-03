module Saphyr
  module Core
    # require './saphyr/core/binding.rb'
    # require './saphyr/core/kernel.rb'

    require './saphyr/core/object.rb'
    require './saphyr/core/method.rb'

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
    require './saphyr/vm/driver.rb'


    # idea
    # supprimmer le binding, string et number
    # modifier le kernel pour le transformer en "class Object"
    # la "class Object" définit la lecture écriture des variables/méthodes
    # toutes les classes hérites de Object
    # le contexte de base est une instance d'Object, définie dans une constante, et accessible via une méthode "main"
    # de cette façon, tout le reste peut etre écrit en saphyr
    # même le mot clé "class" peut être une méthode de "main"
    # et le 'main' pourra faire le lien entre saphyr et ruby (pour instancier en syntaxic sugar des nombres, string, array, hash, ...) (ou sucre syntaxique pour des méthodces genre +, -, *, /, ...)
  end

  def self.[] file_path
    #######################################
    x = Saphyr::VM::Scanner.new(File.open(file_path).read)
    x.scan
    p "STEP 1 : Scan"
    p "#############"
    p *x.characters
    print *["\n"]*3
    #######################################
    x = Saphyr::VM::Lexer.new(File.open(file_path).read)
    x.tokenize
    p "STEP 2 : Tokenize"
    p "#################"
    p *x.tokens
    print *["\n"]*3
    #######################################
    x = Saphyr::VM::Parser.new(File.open(file_path).read)
    x.parse
    p "STEP 3 : Parse"
    p "##############"
    p *x.root
    print *["\n"]*3
    #####################################

    p "STEP 4 : Compile"
    p "##############"


    Saphyr::VM::Driver.new(File.open(file_path).read).read
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
  #
  # CODE
  #
  # Toto = Object.new
  # Toto.prototype = Object.new
  # Toto.prototype.toto = "toto"
  # Toto.new =
  #   instance = Object.new
  #   instance.class = self
  #   instance.methods = self.prototype.methods
  #   instance;
  #
  # obj = Toto.new
  # print obj.toto
  #
  # AST
  #
  # =
  #   Toto
  #   .
  #     Object
  #     new
  # .
  #   Toto
  #   =
  #     prototype
  #     .
  #       Object
  #       new
  # .
  #   Toto
  #   .
  #     prototype
  #     =
  #       toto
  #       "toto"
  # .
  #   Toto
  #   =
  #     new
  #     =
  #       instance
  #       .
  #         Object
  #         new
  #     .
  #       instance
  #       =
  #         class
  #         Toto
  #     .
  #       instance
  #       =
  #         methods
  #         .
  #           Toto
  #           .
  #             prototype
  #             methods
  #     instance
  # =
  #   obj
  #   .
  #     Toto
  #     new
  # .
  #   obj
  #   .
  #     toto
  #     print
  #
  # COMPILE
  #
  # main.define_method("Toto", ast(main.exec_method("Object").exec_method("new")))
  # main.exec_method("Toto").define_method("prototype", ast(main.exec_method("Object").exec_method("new")))
  # main.exec_method("Toto").exec_method("prototype").define_method("toto"), ast("toto"))
  # main.exec_method("Toto").define_method("new", ast(
  #   self.define_method("instance", ast(self.exec_method("Object").exec_method("new")))
  #   self.exec_method("instance").define_method("class", ast(self.exec_method("self")))
  #   self.exec_method("instance").define_method("methods", ast(self.exec_method("self").exec_method("prototype").exec_methods("methods")))
  #   self.exec_method("instance")
  # ))
  # main.define_method("obj", ast(main.exec_method("Toto").exec_method("new")))
  # main.exec_method("obj").exec_method("toto").exec_method("print")
  #
  ##########################














end
