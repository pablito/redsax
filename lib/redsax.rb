# -*- encoding: utf-8 -*-

require "redsax/version"
require 'redsax/document'
require 'redsax/parser'

#
#we aim to write this:
#parser.on(
#    SKUDetails: ->(dom){ puts dom.to_xml},
#    Price:      ->(dom){ puts dom.to_xml}
#)

#we can only write this:
# Redsax::Parser.on('SKUDetails'){|dom| puts dom.to_xml}


module Redsax

end
