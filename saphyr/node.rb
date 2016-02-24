module Saphyr
  class Node
    attr_accessor :token, :level, :children

    def initialize token
      @token = token
      @level = 0
      @children = []
    end

    def add token
      add_node Node.new(token)
    end

    def add_node node
      node.level = level + 1
      children << node
      node
    end

    def inspect
      "#{ "\t"*@level }#{ @token.content }\n" + children.map(&:inspect).join("\n")
    end
  end
end
