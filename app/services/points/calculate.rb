require 'bigdecimal'

class Services::Points::Calculate

  POINTS_FOR_DIRECT_INVITATION =  BigDecimal("1")
  ONE_STEP_COEFFICIENT = BigDecimal("0.5")

  attr_reader :result

  def initialize(invitation_tree)
    @invitation_tree = invitation_tree
    @customers = []
    @result = []
  end

  def perform
    customers
    customers_points
  end

  private

  def customers
    @invitation_tree.each do |node|
      @customers << node.name
    end
  end

  def customers_points
    @customers.each do |customer|
      @result << points_for_all_invites_for(customer)
    end
  end

  def points_for_all_invites_for(customer)
    result = {"#{customer}": BigDecimal("0")}

    subtree_copy(find_node_by(customer)).each do |node|
      # root represents customer in our tree
      next if node.is_root?

      if node.level == 1
        result[:"#{customer}"] += POINTS_FOR_DIRECT_INVITATION
      else
        result[:"#{customer}"] += points_for_one_invite(node.level)
      end
    end
    result
  end

  def find_node_by(customer)
    @invitation_tree.find { |n| n.name == customer }
  end

  def points_for_one_invite(level)
    denominator = BigDecimal("#{level - 1}")
    ONE_STEP_COEFFICIENT / denominator
  end

  def subtree_copy(node)
    node.detached_subtree_copy
  end

end