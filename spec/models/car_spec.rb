require 'rails_helper'
RSpec.describe Car do

  let(:car) { Car.create }

  it 'have 4 wheels' do
    wheels = []
    4.times do
      wheel = Wheel.create
      wheels << wheel
      car.wheels << wheel
    end
    car.reload
    wheels.each do |wheel|
      expect(car.item_children.exists?(child: wheel)).to eq true
      expect(wheel.item_parents.exists?(parent: car)).to eq true
    end
    expect(car.wheels).to match_array wheels
  end

  it 'have no parent' do
    expect(car).to_not respond_to :item_parents
  end
end
