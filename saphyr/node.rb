module Saphyr
  class Node
    attr_accessor :token, :level, :parent, :children

    def initialize token
      @token = token
      @level = 0

      @parent = nil
      @children = []
    end

    def add token
      add_node Node.new(token)
    end

    def add_node node
      node.level = level + 1
      node.parent = self
      children << node

      node
    end

    def swap token
      swap_node Node.new(token)
    end

    def swap_node node
      # p self
      # p self.parent

      parent.children.delete(self)

      node.level = level
      node.parent = parent
      node.children = [self] + children

      parent.children << node

      self.parent = node
      self.children = []
      self.level += 1

      node
    end

    def last_child
      @children.last
    end

    def inspect
      "#{ "\t"*@level }#{ @token.content };\n" + children.map(&:inspect).join
    end
  end
end
