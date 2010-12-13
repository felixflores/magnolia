module Magnolia
  class Tree
    def add_node(parent_path, current_path)
      nodes << {:parent_path => parent_path, :current_path => current_path}
      self
    end

    def nodes
      @nodes ||= []
    end

    def clear
      nodes.clear
    end
  end
end

