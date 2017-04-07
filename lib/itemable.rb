module Itemable
  autoload :ActsAsItemable, 'itemable/acts_as_itemable'
  autoload :ItemRelation, 'itemable/item_relation'
end

require 'itemable/railtie' if defined?(Rails)
