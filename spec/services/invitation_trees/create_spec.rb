require "spec_helper"

RSpec.describe "Create"  do

  context "#with correct data" do

    let(:recommendations) {
                            [{:type=>"recommendation", :sender=>"D", :receiver=>"E",
                              :time=>Time.parse("2018-06-20 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"B", :receiver=>"C",
                             :time=>Time.parse("2018-06-16 09:41:00 +0100")},
                            {:type=>"recommendation", :sender=>"C", :receiver=>"D",
                             :time=>Time.parse("2018-06-19 09:41:00 +0100")}]
                          }

    before(:each) do
      @instance = Services::InvitationTrees::Create.new(recommendations)
    end

    describe '#sorted_recommendations' do

      it 'should set instance variable with recommendations sorted by time' do
        @instance.send(:sorted_recommendations)
        expected_result = [{:type=>"recommendation", :sender=>"B", :receiver=>"C",
                            :time=>Time.parse("2018-06-16 09:41:00 +0100")},
                          {:type=>"recommendation", :sender=>"C", :receiver=>"D",
                            :time=>Time.parse("2018-06-19 09:41:00 +0100")},
                          {:type=>"recommendation", :sender=>"D", :receiver=>"E",
                            :time=>Time.parse("2018-06-20 09:41:00 +0100")}]

        expect(@instance.instance_variable_get(:@sorted_recommendations)).to eq(expected_result)
      end
    end

    describe '#root_node' do

      it "should set instance variable with root node" do
        @instance.send(:root_node)
        expected_result = Tree::TreeNode.new("B")

        expect(@instance.instance_variable_get(:@tree)).to eq(expected_result)
        expect(@instance.instance_variable_get(:@tree).is_root?).to eq(true)
      end

      it "root node should be created using the sender from the first recommendation" do
        first_node_sender = @instance.send(:sorted_recommendations).first[:sender]
        expected_result = Tree::TreeNode.new(first_node_sender)
        @instance.send(:root_node)

        expect(@instance.instance_variable_get(:@tree)).to eq(expected_result)
      end
    end

    describe '#add_first_child_node' do

      it "should add children node to existing tree" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        expected_result = Tree::TreeNode.new("C")

        expect(@instance.instance_variable_get(:@tree).children.first).to eq(expected_result)
      end

      it "children node should be created using the receiver from the first recommendation" do
        first_node_receiver = @instance.send(:sorted_recommendations).first[:receiver]
        expected_result = Tree::TreeNode.new(first_node_receiver)
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)

        expect(@instance.instance_variable_get(:@tree).children.first).to eq(expected_result)
      end
    end

    describe '#find_node_by_sender' do

      let(:node) { {:type=>"recommendation", :sender=>"B", :receiver=>"C", :time=>Time.parse("2018-06-16 09:41:00 +0100")} }

      it "should find correct node by sender name" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        expected_result = "B"

        expect(@instance.send(:find_node_by_sender, node).name).to eq(expected_result)
      end
    end

    describe '#add_child_to' do

      let(:node) { {:type=>"recommendation", :sender=>"B", :receiver=>"C", :time=>Time.parse("2018-06-16 09:41:00 +0100")} }

      it "should add child node to given node" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        last_node = @instance.instance_variable_get(:@tree).children.first

        expect(last_node.children.count).to eq(0)
        @instance.send(:add_child_to, last_node, node)
        expect(last_node.children.count).to eq(1)
      end

      it "should add child node to given node with correct name" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        last_node = @instance.instance_variable_get(:@tree).children.first
        @instance.send(:add_child_to, last_node, node)
        expected_result = "C"

        expect(last_node.children.first.name).to eq(expected_result)
      end
    end

    describe '#insert_node' do

      let(:node) { {:type=>"recommendation", :sender=>"C", :receiver=>"D",
                    :time=>Time.parse("2018-06-16 09:41:00 +0100")} }

      it "should find correct node for insertion" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        last_node = @instance.instance_variable_get(:@tree).children.first
        @instance.send(:insert_node, node)

        expect(last_node.children.first.name).to eq(node[:receiver])
      end
    end

    describe '#update' do

      it "should update the tree by adding correct nodes" do
        @instance.send(:root_node)
        @instance.send(:add_first_child_node)
        @instance.send(:update)

        expect(@instance.instance_variable_get(:@tree).first.name).to eq("B")
        expect(@instance.instance_variable_get(:@tree).first.children.first.name).to eq("C")
        expect(@instance.instance_variable_get(:@tree).first.children.first.children.first.name).to eq("D")
      end
    end
  end
end