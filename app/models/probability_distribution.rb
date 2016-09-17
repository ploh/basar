class ProbabilityDistribution
  attr_reader :size

  private

  class Node
    attr_accessor :children, :parent, :weighting, :content

    def initialize content = nil, weighting = 0.0
      self.children = []
      self.parent = nil
      self.weighting = weighting
      self.content = content
    end

    def is_leaf?
      !content.nil?
    end

    def add child
      if is_leaf?
        parent = self.parent
        parent.remove self, false
        new_inner = Node.new
        new_inner.add self
        new_inner.add child
        parent.add new_inner
      else
        children << child
        add_to_weighting child.weighting
        child.parent = self
      end
    end

    def remove child, cascade = true
      children.delete child
      add_to_weighting -child.weighting
      child.parent = nil
      if cascade && children.empty? && parent
        parent.remove self
      end
    end

    def add_leaf node
      arbitrary_leaf_position.add node
    end

    def draw_leaf
      weight = rand * weighting
      drawn = choose_leaf weight
      drawn.parent.remove drawn if drawn
      drawn
    end

    def to_s
      "#{content}: #{weighting}" + children.map {|child| "\n  " + child.to_s.gsub("\n", "\n  ")}.join
    end

    protected

    def add_to_weighting diff
      self.weighting += diff
      parent.add_to_weighting diff if parent
    end

    def arbitrary_leaf_position
      if children.size < 2
        self
      else
        children[rand 2].arbitrary_leaf_position
      end
    end

    def choose_leaf weight
      if is_leaf?
        self
      elsif children.empty?
        nil
      else
        threshold = children[0].weighting
        chosen_child = nil
        if children.size < 2 || weight < threshold
          chosen_child = children[0]
        else
          chosen_child = children[1]
          weight -= threshold
        end
        chosen_child.choose_leaf weight
      end
    end
  end


  def initialize weighted_contents
    @size = 0
    @root = Node.new
    weighted_contents.each do |content, weighting|
      add content, weighting
    end
  end

  public

  def add content, weighting
    new_node = Node.new content, weighting
    @root.add_leaf new_node
    @size += 1
  end

  def draw
    drawn = @root.draw_leaf
    if drawn
      @size -= 1
      drawn.content
    else
      nil
    end
  end

  def to_s
    "#@root"
  end
end
