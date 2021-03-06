require 'test_helper'

class GraphTest < ActiveSupport::TestCase

    def setup
        @graph = Graph.new
        @vertex_one = Vertex.new 1
        @vertex_two = Vertex.new 2
        @vertex_three = Vertex.new 3
        @vertex_four = Vertex.new 4
        @vertex_five = Vertex.new 5
    end

    def add_vertices
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three
        @graph.add_vertex @vertex_four
        @graph.add_vertex @vertex_five
    end

    test "should add a new vertex" do
        @graph.add_vertex(@vertex_one)
        assert_equal true, @graph.has_vertex?(@vertex_one)
    end

    test "should remove vertex and all your relationships" do
        add_vertices
        @graph.link @vertex_two, @vertex_one
        @graph.remove_vertex @vertex_one
        assert_equal false, @graph.has_vertex?(@vertex_one) || @graph.adjacents(@vertex_two).member?(@vertex_one)
    end

    test "should add two new vertices" do
        add_vertices
        assert_equal true, @graph.has_vertex?(@vertex_one) && @graph.has_vertex?(@vertex_two)
    end

    test "should return random vertex" do
        add_vertices
        assert_equal false, @graph.random_vertex.nil?
    end

    test "should link vertices" do
        add_vertices
        @graph.link @vertex_one, @vertex_two
        assert_equal true, @graph.linked?(@vertex_one, @vertex_two)
    end

    test "should not be linked" do
        add_vertices
        assert_equal false, @graph.linked?(@vertex_two, @vertex_one)
    end

    test "should unlink a vertex" do
        add_vertices
        @graph.link @vertex_one, @vertex_two
        @graph.unlink @vertex_one, @vertex_two
        assert_equal false, @graph.linked?(@vertex_one, @vertex_two)
    end

    test "should return the adjacents of a vertex" do
        add_vertices
        @graph.link @vertex_one, @vertex_two
        @graph.link @vertex_one, @vertex_three
        @graph.link @vertex_three, @vertex_one
        adjacents = @graph.adjacents @vertex_one
        assert_equal true, adjacents.member?(@vertex_two) && adjacents.member?(@vertex_three)
    end

    test "should return the transitive closure of a vertex" do
        add_vertices
        @graph.link @vertex_one, @vertex_two
        @graph.link @vertex_one, @vertex_three
        @graph.link @vertex_three, @vertex_four
        @graph.link @vertex_four, @vertex_five
        transitive_closure = @graph.transitive_closure_of(@vertex_one)
        assert_equal true, transitive_closure.include?(@vertex_one) && transitive_closure.include?(@vertex_two) && transitive_closure.include?(@vertex_three) && transitive_closure.include?(@vertex_four) && transitive_closure.include?(@vertex_five)
    end

    test "should recognize complete graph" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three

        @graph.link @vertex_one, @vertex_two
        @graph.link @vertex_one, @vertex_three


        @graph.link @vertex_two, @vertex_one
        @graph.link @vertex_two, @vertex_three

        @graph.link @vertex_three, @vertex_one
        @graph.link @vertex_three, @vertex_two

        assert_equal true, @graph.complete?
    end

    test "should return a random vertice" do
        add_vertices

        any_vertex = @graph.random_vertex
        assert_equal true, any_vertex.is_a?(Vertex)
        assert_equal true, @graph.has_vertex?(any_vertex)
    end

    test "should return a graph order" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three

        assert_equal true, @graph.order == 3
    end

    test "should return false because graph is not regular" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three

        @graph.link(@vertex_one, @vertex_two)

        assert_equal false, @graph.regular?
    end

    test "should return true because graph is regular" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three
        @graph.add_vertex @vertex_four

        @graph.link(@vertex_one, @vertex_two)
        @graph.link(@vertex_three, @vertex_four)

        assert_equal true, @graph.regular?
    end

    test "should be a disconnect graph" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two

        assert_equal false, @graph.connected?
    end

    test "should be a connected graph" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two

        @graph.link(@vertex_one, @vertex_two)

        assert_equal true, @graph.connected?
    end

    test "should not find a path" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three
        @graph.add_vertex @vertex_four

        @graph.link(@vertex_one, @vertex_two)
        @graph.link(@vertex_one, @vertex_three)

        assert_equal false, @graph.has_path?(@vertex_one, @vertex_four)
    end

    test "should find a path" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three

        @graph.link(@vertex_one, @vertex_two)
        @graph.link(@vertex_two, @vertex_three)

        assert_equal true, @graph.has_path?(@vertex_one, @vertex_three)
    end

    test "should find a path (complexer graph)" do
        @graph.add_vertex @vertex_one
        @graph.add_vertex @vertex_two
        @graph.add_vertex @vertex_three
        @graph.add_vertex @vertex_four

        @graph.link(@vertex_one, @vertex_two)
        @graph.link(@vertex_two, @vertex_three)
        @graph.link(@vertex_three, @vertex_four)

        assert_equal true, @graph.has_path?(@vertex_one, @vertex_four)
    end
end