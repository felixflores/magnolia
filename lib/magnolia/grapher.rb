module Magnolia
  class Grapher
    attr_accessor :dot_notation

    def initialize
      clear
    end

    def add(tree)
      tree.nodes.each do |node|
        insert(node[:parent_path], node[:current_path])
      end
      self
    end

    def clear
      @graph = {}
      @dot_notation = ""
    end

    def graph(filename)
      generate_graph
      self
    end

    def write_to(filename)
      File.open(filename, 'w') {|f| f.write("digraph Magnolia {\n#{@dot_notation}}") }
    end

  private

    def generate_graph
      @graph.each do |parent, children|
        children.each do |path, number_of_times_invoked|
          @dot_notation << "  \"#{parent}\" -> \"#{path}\" [label=#{number_of_times_invoked}];\n"
        end
      end
    end


    def insert(parent_path, current_path)
      return @graph[parent_path] = {current_path => 1} if @graph[parent_path].nil?

      if @graph[parent_path].has_key? current_path
        @graph[parent_path][current_path] += 1
      else
        @graph[parent_path][current_path] = 1
      end
    end
  end
end
