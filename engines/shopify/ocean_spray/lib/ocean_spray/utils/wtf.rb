# frozen_string_literal: true

module Wtf
  def delete_max
    result = nil
    if @root
      @root, result = delete_max_recursive(@root)
      @root.color = :black if @root
    end
    result
  end

  # Iterates over the TreeMap from smallest to largest element. Iterative approach.
  def each
    return nil unless @root
    stack = Containers::Stack.new
    cursor = @root
    loop do
      if cursor
        stack.push(cursor)
        cursor = cursor.left
      else
        unless stack.empty?
          cursor = stack.pop
          yield(cursor.key, cursor.value)
          cursor = cursor.right
        else
          break
        end
      end
    end
  end

  class Node # :nodoc: all
    attr_accessor :color, :key, :value, :left, :right, :size, :height
    def initialize(key, value)
      @key = key
      @value = value
      @color = :red
      @left = nil
      @right = nil
      @size = 1
      @height = 1
    end

    def red?
      @color == :red
    end

    def colorflip
      @color       = @color == :red       ? :black : :red
      @left.color  = @left.color == :red  ? :black : :red
      @right.color = @right.color == :red ? :black : :red
    end

    def update_size
      @size = (@left ? @left.size : 0) + (@right ? @right.size : 0) + 1
      left_height = (@left ? @left.height : 0)
      right_height = (@right ? @right.height : 0)
      if left_height > right_height
        @height = left_height + 1
      else
        @height = right_height + 1
      end
      self
    end

    def rotate_left
      r = @right
      r_key, r_value, r_color = r.key, r.value, r.color
      b = r.left
      r.left = @left
      @left = r
      @right = r.right
      r.right = b
      r.color, r.key, r.value = :red, @key, @value
      @key, @value = r_key, r_value
      r.update_size
      update_size
    end

    def rotate_right
      l = @left
      l_key, l_value, l_color = l.key, l.value, l.color
      b = l.right
      l.right = @right
      @right = l
      @left = l.left
      l.left = b
      l.color, l.key, l.value = :red, @key, @value
      @key, @value = l_key, l_value
      l.update_size
      update_size
    end

    def move_red_left
      colorflip
      if (@right.left && @right.left.red?)
        @right.rotate_right
        rotate_left
        colorflip
      end
      self
    end

    def move_red_right
      colorflip
      if (@left.left && @left.left.red?)
        rotate_right
        colorflip
      end
      self
    end

    def fixup
      rotate_left if @right && @right.red?
      rotate_right if (@left && @left.red?) && (@left.left&.red?)
      colorflip if (@left && @left.red?) && (@right && @right.red?)

      update_size
    end
  end

  def delete_recursive(node, key)
    if (key <=> node.key) == -1
      node.move_red_left if ( !isred(node.left) && !isred(node.left.left) )
      node.left, result = delete_recursive(node.left, key)
    else
      node.rotate_right if isred(node.left)
      if ((key <=> node.key) == 0) && node.right.nil?
        return nil, node.value
      end
      if !isred(node.right) && !isred(node.right.left)
        node.move_red_right
      end
      if (key <=> node.key) == 0
        result = node.value
        node.value = get_recursive(node.right, min_recursive(node.right))
        node.key = min_recursive(node.right)
        node.right = delete_min_recursive(node.right).first
      else
        node.right, result = delete_recursive(node.right, key)
      end
    end
    return node.fixup, result
  end
  private :delete_recursive

  def delete_min_recursive(node)
    if node.left.nil?
      return nil, node.value
    end
    if !isred(node.left) && !isred(node.left.left)
      node.move_red_left
    end
    node.left, result = delete_min_recursive(node.left)

    return node.fixup, result
  end
  private :delete_min_recursive

  def delete_max_recursive(node)
    if (isred(node.left))
      node = node.rotate_right
    end
    return nil, node.value if node.right.nil?
    if ( !isred(node.right) && !isred(node.right.left) )
      node.move_red_right
    end
    node.right, result = delete_max_recursive(node.right)

    return node.fixup, result
  end
  private :delete_max_recursive

  def get_recursive(node, key)
    return nil if node.nil?
    case key <=> node.key
    when  0 then return node.value
    when -1 then return get_recursive(node.left, key)
    when  1 then return get_recursive(node.right, key)
    end
  end
  private :get_recursive

  def min_recursive(node)
    return node.key if node.left.nil?

    min_recursive(node.left)
  end
  private :min_recursive

  def max_recursive(node)
    return node.key if node.right.nil?

    max_recursive(node.right)
  end
  private :max_recursive

  def insert(node, key, value)
    return Node.new(key, value) unless node

    case key <=> node.key
    when  0 then node.value = value
    when -1 then node.left = insert(node.left, key, value)
    when  1 then node.right = insert(node.right, key, value)
    end

    node.rotate_left if (node.right && node.right.red?)
    node.rotate_right if (node.left && node.left.red? && node.left.left && node.left.left.red?)
    node.colorflip if (node.left && node.left.red? && node.right && node.right.red?)
    node.update_size
  end
  private :insert

  def isred(node)
    return false if node.nil?

    node.color == :red
  end
  private :isred
end

begin
  require 'CRBTreeMap'
  Containers::RBTreeMap = Containers::CRBTreeMap
rescue LoadError # C Version could not be found, try ruby version
  Containers::RBTreeMap = Containers::RubyRBTreeMap
end

