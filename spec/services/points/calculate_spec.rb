require "spec_helper"


RSpec.describe "Calculate"  do

  context "#with correct data" do

    let(:tree) { Tree::TreeNode.from_hash({"A"=>{"B"=>{"C"=>{"D"=>{}}}}}) }

    before(:each) do
      @instance =  Services::Points::Calculate.new(tree)
    end

    describe '#initialize' do

      it 'should initialize correct instance' do
        expect(@instance.result).to eq([])
        expect(@instance.instance_variable_get(:@customers)).to eq([])
        expect(@instance.instance_variable_get(:@invitation_tree)).to eq(tree)
      end
    end

    describe '#customers' do

      it 'should set all customers' do
        @instance.send(:customers)
        expected_result = ["A", "B", "C", "D"]
        expect(@instance.instance_variable_get(:@customers)).to eq(expected_result)
      end
    end

    describe '#find_node_by' do

      let(:customer) { "B" }

      it 'should find node by customer name' do
        @instance.send(:customers)
        expected_result = "B"
        expect(@instance.send(:find_node_by, customer).name).to eq(expected_result)
      end
    end

    describe '#points_for_one_invite' do

      it 'should calculate points depending on level' do
        level = 1
        expect(@instance.send(:points_for_one_invite, level)).to eq(BigDecimal::INFINITY)
        level = 2
        expect(@instance.send(:points_for_one_invite, level)).to eq(BigDecimal("0.5"))
        level = 3
        expect(@instance.send(:points_for_one_invite, level)).to eq(BigDecimal("0.25"))
      end
    end

    describe '#denominator' do

      it 'should calculate denominator' do
        level = 1
        expect(@instance.send(:denominator, level)).to eq(BigDecimal("0.0"))
        level = 2
        expect(@instance.send(:denominator, level)).to eq(BigDecimal("1"))
        level = 3
        expect(@instance.send(:denominator, level)).to eq(BigDecimal("2"))
      end
    end

    describe '#subtree_copy' do

      let(:new_tree) { Tree::TreeNode.from_hash({"B"=>{"C"=>{"D"=>{}}}}) }

      it 'should create subtree copy starting from selected node' do
        node = tree.children.first
        expect(@instance.send(:subtree_copy, node)).to eq(new_tree)
      end
    end


    describe '#points_for_all_invites_for' do

      let(:customer_one) { "A" }
      let(:customer_two) { "B" }
      let(:customer_three) { "C" }

      it 'should create subtree copy starting from selected node' do
        expected_result_a = {"A": BigDecimal("1.75")}
        expect(@instance.send(:points_for_all_invites_for, customer_one)).to eq(expected_result_a)

        expected_result_b = {"B": BigDecimal("1.5")}
        expect(@instance.send(:points_for_all_invites_for, customer_two)).to eq(expected_result_b)

        expected_result_c = {"C": BigDecimal("1.0")}
        expect(@instance.send(:points_for_all_invites_for, customer_three)).to eq(expected_result_c)
      end
    end
  end
end