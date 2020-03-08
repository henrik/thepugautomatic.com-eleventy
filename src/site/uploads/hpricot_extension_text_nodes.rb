# By Henrik Nyh <http://henrik.nyh.se> 2007-05-12.
# Adds a method #text_nodes to Hpricot nodes that returns all descendant text nodes in order.

require "rubygems"
require "hpricot"

module HpricotTextNodesExtension
    module Tags
        def text_nodes
            (respond_to?(:children) ? children : []).inject(Hpricot::Elements[]) { |a,e| a += e.text_nodes }
        end
    end
    module Text
        def text_nodes() Hpricot::Elements[self] end
    end
end

Hpricot::Doc.send(:include, HpricotTextNodesExtension::Tags)
Hpricot::BaseEle.send(:include, HpricotTextNodesExtension::Tags)
Hpricot::Elem.send(:include, HpricotTextNodesExtension::Tags)
Hpricot::Text.send(:include, HpricotTextNodesExtension::Text)

if __FILE__ == $0
    
    require "test/unit"

    class HpricotTextNodesTest < Test::Unit::TestCase
        def assert_values(expected_values, nodes)
            assert_equal expected_values.length, nodes.length
            nodes.each_with_index do |e,i|
                assert_equal Hpricot::Text, e.class
                assert_equal expected_values[i], e.content
            end 
        end
        def test_element
            doc = Hpricot("1 <div>2 <div>3 <span>4 5</span> 6</div>7</div> 8 <span>9</span>")
            text_nodes = doc.text_nodes
            assert_values ["1 ", "2 ", "3 ", "4 5", " 6", "7", " 8 ", "9"], text_nodes
        end
        def test_text_node
            doc = Hpricot::Text.new("halloa")
            text_nodes = doc.text_nodes
            assert_values ["halloa"], text_nodes
        end
        def test_title_as_text_node
            # This test is mostly to document this (perhaps unexpected) behavior
            doc = Hpricot("<html><head><title>Title</title></head><body>Body</body></html>")
            text_nodes = doc.text_nodes
            assert_values ["Title", "Body"], text_nodes
        end
    end

end