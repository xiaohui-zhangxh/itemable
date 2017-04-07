require 'rails_helper'
RSpec.describe 'Build a Car' do
  let(:car) { Car.create }
  before do
    4.times do
      car.wheels << Wheel.create
    end
    3.times do
      car.chairs << Chair.create
    end
    wheel = Wheel.first
    wheel.tyre = Tyre.create
    5.times do
      wheel.screws << Screw.create
    end
    car.reload
  end

  it { expect(car.item_children.count).to eq 7 }
  it { expect(car.item_children.map(&:child)).to match_array(Wheel.all + Chair.all) }
  it { expect(car.wheels.count).to eq 4 }
  it { expect(car.wheels).to match_array Wheel.all }
  it { expect(car.chairs.count).to eq 3 }
  it { expect(car.chairs).to match_array Chair.all }

  context 'Wheel One' do
    let(:wheel) { Wheel.first }
    let(:tyre) { Tyre.first }
    it { expect(wheel.item_children.count).to eq 6 }
    it { expect(wheel.item_children.map(&:child)).to match_array(Tyre.all + Screw.all) }
    it { expect(wheel.tyre).to eq(tyre) }
    it { expect(wheel.screws.count).to eq 5 }
    it { expect(wheel.screws).to match_array Screw.all }
  end

  context 'Wheel Two' do
    let(:wheel) { Wheel.second }
    it { expect(wheel.item_children.count).to eq 0 }
    it do
      wheel.tyre = Tyre.create
      expect(wheel.item_children.count).to eq 1
    end
  end
end
