# -*- encoding: utf-8 -*-

require 'nokogiri'
module Redsax
  class Document < Nokogiri::XML::SAX::Document

    def self.on(name, &block)
      new(name, &block)
    end

    def initialize(name, &block)
      @block = block
      @name = name
      @status = :waiting
      @namespaces = []
      @depth = 0
    end

    def start_element name, attrs = []
      namespaces, attributes = attrs.partition{|tuple| tuple.first.start_with?('xmlns')}
      if waiting?
        if name == @name
          start_collecting
          @buffer = root.add_child(new_element(name, attributes, @namespaces + namespaces))
        else
          store(namespaces)
        end
      elsif collecting?
        @buffer = @buffer.add_child(new_element(name, attributes, namespaces))
        @depth += 1
      end
    end

    def characters(str)
      if collecting?
        @buffer.add_child(root.create_text_node(str))
      end
    end

    def end_element name
      if collecting?
        @buffer = @buffer.parent unless @buffer.parent.nil?
        @depth -= 1
        if name == @name && @depth == 0
          @block[root]
          end_collecting
        end
      end
    end

    def xmldecl(version, encoding, standalone)
      @encoding = encoding || 'utf-8'
      @version = version || '1.0'
      @standalone = standalone || 'yes'
    end

    def cdata_block(string)
      if collecting?
        @buffer.add_child(root.create_cdata(string))
      end
    end

    def comment(string)
      if collecting?
        @buffer.add_child(root.create_comment(string))
      end
    end
    private

    def store(namespaces)
      @namespaces += namespaces
    end
    def end_collecting
      @status = :waiting
      @root = nil
    end

    def start_collecting
      @status = :collecting
      @depth = 1
    end

    def collecting?
      @status == :collecting
    end

    def waiting?
      @status == :waiting
    end

    def new_element(name, attributes, namespaces)
      node = root.create_element(name, Hash[attributes].merge(Hash[namespaces]))
      node
    end

    def root()
      @root ||= Nokogiri::XML::Document.new(version: @version).tap{|dom| dom.encoding = @encoding}
    end
  end
end
