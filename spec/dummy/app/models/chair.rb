class Chair < ApplicationRecord
  acts_as_itemable sti: true, children: false, child: false
  belongs_to_item :car
end
