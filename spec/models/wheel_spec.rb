require 'rails_helper'
RSpec.describe Wheel do

  let(:car) { Car.create }
  let(:wheel) { Wheel.create }
  let(:tyre) { Tyre.create }

  it 'belongs to item: car' do
    wheel.create_item_parent(parent: car)
    wheel.reload
    expect(wheel.car).to eq(car)
    expect(car.item_children.exists?(child: wheel)).to eq(true)
  end

  it 'has one item: tyre' do
    wheel.create_item_child(child: tyre)
    wheel.reload
    expect(wheel.tyre).to eq tyre
    expect(tyre.wheel).to eq wheel
  end

  it 'has many items: screw' do
    screws = []
    5.times do
      screw = Screw.create
      screws << screw
      wheel.screws << screw
    end
    wheel.reload
    expect(wheel.screws).to match_array screws
  end
end
