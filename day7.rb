# frozen_string_literal: true

require './lib/runner'

class Node
  File   = Data.define(:name, :bytes)
  Folder = Data.define(:name, :parent, :children) do
    def bytes
      children.sum(&:bytes)
    end
  end

  def self.init(root)
    Folder.new(root, nil, [])
  end

  def self.create_from(str, parent)
    if str.start_with?('dir')
      dirname = str.split(' ').last
      Folder.new(dirname, parent, [])
    else
      _, size, name = str.match(/(^\d+) (.+)/).to_a
      File.new(name, size.to_i)
    end
  end

  def self.traverse(node, memo, &block)
    return memo if node.is_a? File

    memo = node.children.reduce(memo) { |submemo, subnode| traverse(subnode, submemo, &block) }
    yield(memo, node)
  end
end

class Day7 < Runner
  FOLDER_MAX_BYTES = 100_000
  MAX_USABLE_SPACE = 70_000_000 - 30_000_000

  def do_puzzle1
    root = build_tree(@input)

    Node.traverse(root, 0) do |total, node|
      if node.bytes <= FOLDER_MAX_BYTES
        total + node.bytes
      else
        total
      end
    end
  end

  def do_puzzle2
    root = build_tree(@input)

    target_min_above = root.bytes - MAX_USABLE_SPACE
    Node.traverse(root, root.bytes) do |curr_min_above, node|
      next curr_min_above if node.bytes < target_min_above
      next curr_min_above if node.bytes >= curr_min_above

      node.bytes
    end
  end

  def build_tree(input)
    root = curr_node = Node.init('/')

    input
      .split("\n$ ")
      .tap { _1.shift } # Discard the "$ cd /"
      .each do |command|
        case command
        in 'cd ..'
          curr_node = curr_node.parent
        in 'cd /'
          curr_node = root
        in /^cd/
          dirname = command.match(/cd (.+)/)[1]

          curr_node = curr_node.children.find { _1.name == dirname }
        in /^ls/
          nodes = command
                  .split("\n")
                  .tap { _1.shift } # Discard the ls
                  .map { |content| Node.create_from(content, curr_node) }
          curr_node.children.concat(nodes)
        else
          raise "What is this command?? \"#{command}\""
        end
      end

    root
  end

  def parse(raw_input)
    raw_input
  end
end
