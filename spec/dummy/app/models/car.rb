class Car < ApplicationRecord
  acts_as_itemable parents: false, parent: false
  has_many_items :wheels, dependent: :destroy
  has_many_items :chairs
end
