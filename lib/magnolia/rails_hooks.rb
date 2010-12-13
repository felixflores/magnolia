module Magnolia
  mattr_accessor :tree
  @@tree = Tree.new
end

class ActionView::Base
  include Magnolia

  @@parent_stack = []

  def render_with_magnolia_render(*args)
    current_path = magnolia_current_path(args)
    tree.add_node(magnolia_parent_path, current_path)

    @@parent_stack << current_path
    result = render_without_magnolia_render(*args)
    @@parent_stack.pop

    result
  end

  alias_method_chain :render, :magnolia_render

private
  def magnolia_parent_path
    @@parent_stack.last || "#{controller.controller_name}##{controller.action_name}"
  end

  def magnolia_current_path(args)
    options = args[0]

    if options.kind_of?(Hash)
      if options[:file]
        view_paths.find_template(options[:file]).path
      elsif options[:partial]
        magnolia_partial_path(options[:partial])
      end
    else
      magnolia_partial_path(options)
    end
  end

  def magnolia_partial_path(partial_path)
    if partial_path.include?('/')
      path = File.join(File.dirname(partial_path), "_#{File.basename(partial_path)}")
    elsif controller
      path = "#{controller.class.controller_path}/_#{partial_path}"
    else
      path = "_#{partial_path}"
    end

    view_paths.find_template(path, template_format).path
  end
end

class ActionController::Base
  include Magnolia

  def process_cleanup
    Grapher.new.add(tree).graph.clear
    puts "tree nodes: #{tree.nodes.inspect}"
    tree.clear
  end
end

