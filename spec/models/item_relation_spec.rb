require 'rails_helper'
RSpec.describe Itemable::ItemRelation do

  subject { Itemable::ItemRelation.new }

  it { expect(subject.class.table_name).to eq('itemable_item_relations') }
  it { should respond_to :parent }
  it { should respond_to :child }
end
