class Tyre < ApplicationRecord
  acts_as_itemable sti: true, children: false
  belongs_to_item :wheel
end
