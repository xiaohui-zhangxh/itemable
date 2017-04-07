require 'rails_helper'
RSpec.describe 'acts_as_itemable' do

  it 'is included to ActiveRecord' do
    model = Class.new(ActiveRecord::Base)
    expect(model).to respond_to :acts_as_itemable
  end

  it 'without sti: true' do
    model = Class.new(ActiveRecord::Base) do
      acts_as_itemable
      def self.name
        'MyModel'
      end
    end
    expect(model.table_name).to eq('my_models')
  end

  it 'with sti: true' do
    model = Class.new(ActiveRecord::Base) do
      acts_as_itemable sti: true
      def self.name
        'MyModel'
      end
    end
    expect(model.table_name).to eq('itemable_items')
  end

  describe 'creates associations' do
    subject do
      Class.new(ActiveRecord::Base) do
        acts_as_itemable sti: true
        def self.name
          'MyModel'
        end
      end.new
    end
    it { expect(subject.item_children).to be_a ActiveRecord::Associations::CollectionProxy }
    it { expect(subject).to respond_to :item_child }
    it { expect(subject.item_parents).to be_a ActiveRecord::Associations::CollectionProxy }
    it { expect(subject).to respond_to :item_parent }
  end

  describe 'without children association' do
    subject do
      Class.new(ActiveRecord::Base) do
        acts_as_itemable sti: true, children: false
        def self.name
          'MyModel'
        end
      end.new
    end
    it { expect(subject).to_not respond_to :item_children }
  end

  describe 'without child association' do
    subject do
      Class.new(ActiveRecord::Base) do
        acts_as_itemable sti: true, child: false
        def self.name
          'MyModel'
        end
      end.new
    end
    it { expect(subject).to_not respond_to :item_child }
  end

  describe 'without parents association' do
    subject do
      Class.new(ActiveRecord::Base) do
        acts_as_itemable sti: true, parents: false
        def self.name
          'MyModel'
        end
      end.new
    end
    it { expect(subject).to_not respond_to :item_parents }
  end

  describe 'without parent association' do
    subject do
      Class.new(ActiveRecord::Base) do
        acts_as_itemable sti: true, parent: false
        def self.name
          'MyModel'
        end
      end.new
    end
    it { expect(subject).to_not respond_to :item_parent }
  end
end
