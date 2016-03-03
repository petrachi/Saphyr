class Saphyr::VM::Node
  attr_accessor :children, :level, :parent, :token

  def self.root
    new Saphyr::VM::Token.new('', '', 0, 0)
  end

  def self.subtree children = nil
    subtree = root
    Array(children).each do |child_node|
      subtree.add_node child_node
    end
    subtree
  end

  def initialize token
    @token = token
    @level = 0

    @parent = nil
    @children = []
  end

  def level= value
    @level = value
    @children.each{ |child| child.level = value + 1 }
  end

  def add token
    add_node Saphyr::VM::Node.new(token)
  end

  def add_node node
    node.level = level + 1
    node.parent = self
    children << node

    node
  end

  def swap token
    swap_node Saphyr::VM::Node.new(token)
  end

  def swap_node node
    parent.children.delete(self)

    node.level = level
    node.parent = parent
    node.children = [self]

    parent.children << node

    self.parent = node
    self.level += 1

    node
  end

  def merge subtree
    subtree.children.each do |child|
      add_node child
    end
  end

  def last_child
    children.last
  end

  def inspect
    "#{ "\t" * level }#{ token.content.inspect }(#{ token.line }, #{ token.column });\n" + children.map(&:inspect).join
  end
end
