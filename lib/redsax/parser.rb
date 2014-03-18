# -*- encoding: utf-8 -*-
module Redsax
  class Parser < Nokogiri::XML::SAX::Parser
    def self.on(name, &block)
      new(Document.on(name, &block))
    end
  end
end

#parser = Redsax::Parser.on('SKUDetails') do |root|
#  puts "#{ebay_id}\t#{root.xpath('SKUDetails/SKU/text()')}\t#{root.xpath('SKUDetails/Quantity/text()')}\t#{root.xpath('SKUDetails/Price/text()')}\t#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
#end


