class Saphyr::Core::Object
  attr_accessor :locals

  def initialize
    @locals = {}
    @locals.define_singleton_method("print", ->{ ::Kernel.print self })
  end

  def define_method name, ast
    # p "defining method ''#{name}'' for #{self}"
    # p "ast look : #{ ast.inspect}"

    locals[name] = Saphyr::Core::Method.new(name, ast)
  end

  def exec_method name
    unless locals.has_key? name
      # p "declaring a new object '#{name}' within self"
      locals[name] = self.class.new
    end

    # p "calling '#{name}'"
    locals[name].call self
  end

  def self.exec_method name
    # p "ruby method : exec method ''#{name}'' for #{self}"
    send name
  end

  def call object
    object
  end

  def methods
    # return all methods objects (or all locals ?)
  end

  def print
    ::Kernel.print sprint
  end

  def sprint
    "an Object"
    # should look like #<[object class name]#[object id]>
  end
end
