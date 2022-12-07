# frozen_string_literal: true

require './lib/runner'

class Node
  Fil = Struct.new(:name, :parent, :bytes)

  Folder = Struct.new(:name, :parent, :children) do
    def bytes
      children.sum(&:bytes)
    end
  end

  def self.init(root)
    Folder.new(root, nil, [])
  end

  def self.create(str)
    case str
    when /dir/
      dirname = str.split(' ').last
      Folder.new(dirname, nil, [])
    when /^\d+/
      m, size, filname = str.match(/(\d+) (.+)/).to_a
      Fil.new(filname, nil, size.to_i)
    else
      raise "What is this??? #{str}"
    end
  end

  def self.traverse(node, &block)
    return if node.is_a? Fil

    node.children.map { traverse(_1, &block) }
    yield(node)
  end
end

class Day7 < Runner
  def build_tree
    parse_cmd = ->(command) {
      case command
      when /^cd/
        dirname = command.match(/cd (.+)/)[1]
        [:cd, dirname]
      when /^ls/
        nodes = command
                .split("\n")
                .tap { _1.shift } # Discard the ls
                .map { |node| Node.create(node) }
        [:ls, nodes]
      else
        raise "What is this command?? \"#{command}\""
      end
    }

    root = Node.init('/')
    curr_node = root

    @input.split("\n$ ").tap { _1.shift }.map(&parse_cmd).map do |cmd|
      action, data = cmd
      if action == :ls
        data.each do |node|
          node.parent = curr_node
        end
        curr_node.children = data
      elsif action == :cd
        curr_node = case data
                    when '..'
                      curr_node.parent
                    when '/'
                      root
                    else
                      curr_node.children.find { _1.name == data }
                    end
      end
    end

    root
  end

  def do_puzzle1
    root = build_tree
    total = 0
    Node.traverse(root) do |node|
      total += node.bytes if node.bytes <= 100_000
    end
    total
  end

  def do_puzzle2
    root = build_tree

    current_free = 70_000_000 - root.bytes
    target_min_above = 30_000_000 - current_free

    curr_min_above = root.bytes
    Node.traverse(root) do |node|
      next if node.bytes < target_min_above
      next if node.bytes >= curr_min_above

      curr_min_above = node.bytes
    end

    curr_min_above
  end

  def parse(raw_input)
    raw_input
  end
end
