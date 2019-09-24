class Services::InvitationTrees::Create

  attr_reader :tree

  def initialize(recommendations)
    @recommendations = recommendations
  end

  def perform
    root_node
    add_first_child_node
    update
  end

  private

  def root_node
    @tree = Tree::TreeNode.new(sorted_recommendations.first[:sender])
  end

  def add_first_child_node
    @tree.root << Tree::TreeNode.new(sorted_recommendations.first[:receiver])
  end

  def sorted_recommendations
    @sorted_recommendations ||= @recommendations.sort_by { |rec| rec[:time] }
  end

  def update
    sorted_recommendations.drop(1).each do |node|
      insert_node(node)
    end
  end

  def insert_node(new_node)
    last_node = find_node_by_sender(new_node)
    add_child_to(last_node, new_node)
  end

  def find_node_by_sender(node)
    @tree.find { |n| n.name == node[:sender]}
  end

  def add_child_to(last_node, node)
    last_node <<  Tree::TreeNode.new(node[:receiver])
  end

end