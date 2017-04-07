module Itemable
  class ItemRelation < ActiveRecord::Base
    self.table_name = 'itemable_item_relations'
    belongs_to :parent, polymorphic: true
    belongs_to :child, polymorphic: true
  end
end
