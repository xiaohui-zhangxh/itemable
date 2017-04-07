class Wheel < ApplicationRecord
  acts_as_itemable sti: true
  has_one_item :tyre, dependent: :destroy
  belongs_to_item :car
  has_many_items :screws, dependent: :destroy
end
