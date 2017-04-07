module Itemable
  module ActsAsItemable
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_itemable(sti: false, parents: true, children: true, child: true, parent: true)
        if sti
          self.table_name = "itemable_items"
          self.instance_variable_set('@finder_needs_type_condition', :true)
        end

        if children
          include ChildrenAssociation
          include HasManyItems
        end

        if child
          include ChildAssociation
          include HasOneItem
        end

        if parents
          include ParentsAssociation
          include BelongsToItems
        end

        if parent
          include ParentAssociation
          include BelongsToItem
        end
      end
    end

    module HasManyItems
      extend ActiveSupport::Concern
      module ClassMethods
        def has_many_items(association_name, options={})
          default_options = {
            through: :item_children,
            source: :child,
            source_type: association_name.to_s.classify
          }
          has_many association_name, default_options.merge(options.symbolize_keys)
        end
      end
    end

    module HasOneItem
      extend ActiveSupport::Concern
      module ClassMethods
        def has_one_item(association_name, options={})
          default_options = {
            through: :item_child,
            source: :child,
            source_type: association_name.to_s.classify
          }
          has_one association_name, default_options.merge(options.symbolize_keys)
        end
      end
    end

    module BelongsToItems
      extend ActiveSupport::Concern
      module ClassMethods
        def belongs_to_items(association_name, options={})
          default_options = {
            through: :item_parents,
            source: :parent,
            source_type: association_name.to_s.classify
          }
          has_many association_name, default_options.merge(options.symbolize_keys)
        end
      end
    end

    module BelongsToItem
      extend ActiveSupport::Concern
      module ClassMethods
        def belongs_to_item(association_name, options={})
          default_options = {
            through: :item_parent,
            source: :parent,
            source_type: association_name.to_s.classify
          }
          has_one association_name, default_options.merge(options.symbolize_keys)
        end
      end
    end

    module ChildrenAssociation
      extend ActiveSupport::Concern
      included do
        has_many :item_children,
                 class_name: 'Itemable::ItemRelation',
                 as: :parent,
                 dependent: :destroy
      end
    end

    module ChildAssociation
      extend ActiveSupport::Concern
      included do
        has_one :item_child,
                class_name: 'Itemable::ItemRelation',
                as: :parent,
                dependent: :destroy
      end
    end

    module ParentsAssociation
      extend ActiveSupport::Concern
      included do
        has_many :item_parents,
                 class_name: 'Itemable::ItemRelation',
                 as: :child,
                 dependent: :destroy
      end
    end

    module ParentAssociation
      extend ActiveSupport::Concern
      included do
        has_one :item_parent,
                 class_name: 'Itemable::ItemRelation',
                 as: :child,
                 dependent: :destroy
      end
    end
  end
end
