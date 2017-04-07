class Screw < ApplicationRecord
  acts_as_itemable sti: true, children: false, parents: false, child: false
  belongs_to_item :wheel
end
