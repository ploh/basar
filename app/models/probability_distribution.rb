class ProbabilityDistribution
  attr_reader :size

  private

  class Node
    attr_accessor :parent, :weighting

    def initialize
      self.parent = nil
      self.weighting = 0.0
    end

    def to_s
      "#{weighting}"
    end
  end

  class InnerNode < Node
    attr_accessor :children

    def initialize
      super
      self.children = []
    end

    def add_child child
      children << child
      add_to_weighting child.weighting
      child.parent = self
    end

    def remove_child child
      children.delete child
      add_to_weighting -child.weighting
      child.parent = nil
    end

    def to_s
      super + "\n" + self.children.map {|child| "  " + child.to_s.gsub("\n", "\n  ")}.join("\n")
    end

    protected

    def add_to_weighting diff
      self.weighting += diff
      parent.add_to_weighting diff if self.parent
    end
  end

  class OuterNode < Node
    attr_accessor :content

    def initialize content, weighting
      super()
      self.weighting = weighting.to_f
      self.content = content
    end

    def to_s
      "#{content}: #{super}"
    end
  end


  def initialize weighted_contents
    @size = 0
    weighted_contents.each do |content, weighting|
      add content, weighting
    end
  end

  public

  def add content, weighting
    @size += 1
    new_node = OuterNode.new content, weighting
    if @root
      last = current = @root
      while current
        parent = current.parent
        if current.kind_of? OuterNode
          new_inner = InnerNode.new
          if parent
            parent.remove_child current
            parent.add_child new_inner
          else
            @root = new_inner
          end
          new_inner.add_child current
          current = new_inner
        end
        last = current
        children = current.children
        current = children.size >= 2 && children[rand 2]
      end
      last.add_child new_node
    else
      @root = new_node
    end
    self
  end

  def draw
    if @root && @root.weighting > 0
      @size -= 1
      remaining_weight = rand * @root.weighting
      current = @root
      while current.kind_of?(InnerNode) && !current.children.empty?
        children = current.children
        weighting_threshold = children[0].weighting
        if children.size < 2 || remaining_weight < weighting_threshold
          current = children[0]
        else
          current = children[1]
          remaining_weight -= weighting_threshold
        end
      end

      if parent = current.parent
        parent.remove_child current
      else
        @root = nil
        @size = 0
      end

      if current.kind_of?(OuterNode)
        current.content
      else
        nil
      end
    else
      nil
    end
  end

  def to_s
    @root ? "#@root" : ""
  end
end
