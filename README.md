# Itemable [![Build Status](https://travis-ci.org/xiaohui-zhangxh/itemable.svg?branch=master)](https://travis-ci.org/xiaohui-zhangxh/itemable) [![Gem Version](https://badge.fury.io/rb/itemable.svg)](https://badge.fury.io/rb/itemable)

Make your ActiveRecord model as a item, it can be child or parent of self-modle or other-model

## When will you need this gem?

Think about you are using PostgreSQL database, you just want to simplely store some unusually-query data into one table, put various files into one jsonb filed, record many have some child records, or parent records, such as a Car has many accessories: 4 Wheels, 3 Chairs, and a Wheel has one Tyre, 5 Screws. I don't care how to store them, just care about their relations, so now let's make this with `Itemable`:

1. Setup `Itemable`
2. Create Models `Car`, `Wheel`, `Chair`, `Tyre`, `Screw`
3. Create relations to each model

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'itemable'
```

And then execute below to create tables `itemable_items` and `itemable_item_relations`:

```bash
$ rails g itemable:migration
$ rake db:migrate
```

## Usage

Create `Car` modle

```
$ rails g model car name
```

Update `app/models/car.rb`:

    class Car < ActiveRecord::Base
        acts_as_itemable
        has_many_items :wheels, dependent: :destroy
        has_many_items :chairs, dependent: :destroy
    end

- `acts_as_itemable` makes `Car` has all feature of `Itemable`  
- `has_many_items :wheels` declares a car has many wheels  
- `has_many_items :chairs` declares a car has many chairs  

Create `Wheel` model without db migration:

Add `app/models/wheel.rb`

    class Wheel < ActiveRecord::Base
        acts_as_itemable sti: true
        belongs_to_item :car
        has_many_items :screws, dependent: :destroy
        has_one_item: :tyre, dependent: :destroy
    end

- `acts_as_itemable sti: true`, `sti = true` means `Wheel` is a single table inherited Model, will get records from table `itemable_items`
- `belongs_to_item :car` declares wheel belongs to car
- `has_one_item: :tyre` declares wheel has only one tyre

Add `app/models/chair.rb`

    class Chair < ActiveRecord::Base
        acts_as_itemable sti: true
        belongs_to_item :car
    end

Add `app/models/tyre.rb`

    class Tyre < ActiveRecord::Base
        acts_as_itemable sti: true
        belongs_to_item :wheel
    end

Add `app/models/screw.rb`

    class Screw < ActiveRecord::Base
        acts_as_itemable sti: true
        belongs_to_item :wheel
    end

**Now everything is ready, let store/query data**

```ruby
car = Car.create
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
car.item_children.count => 7
car.item_children.map(&:child)
=> [#<Wheel:0x007f86ba65f930 id: 16, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86ba677fa8 id: 17, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86ba685568 id: 18, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86ba69c038 id: 19, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Chair:0x007f86ba6cd0e8 id: 20, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>,
 #<Chair:0x007f86ba6e4e28 id: 21, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>,
 #<Chair:0x007f86ba706c58 id: 22, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>]
car.wheels.count => 4
=> [#<Wheel:0x007f86c018b8e0 id: 16, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86c018b750 id: 17, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86c018b5c0 id: 18, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>,
 #<Wheel:0x007f86c018b430 id: 19, type: "Wheel", created_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:18 UTC +00:00>]
car.chairs.count => 3
=> [#<Chair:0x007f86be2baab0 id: 20, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>,
 #<Chair:0x007f86be2ba830 id: 21, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>,
 #<Chair:0x007f86be2ba538 id: 22, type: "Chair", created_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:22 UTC +00:00>]
wheels = car.wheels
wheels[0].item_children.count => 6
wheels[0].item_children.map(&:child)
=> [#<Tyre:0x007f86be44f290 id: 23, type: "Tyre", created_at: Fri, 07 Apr 2017 04:53:33 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:33 UTC +00:00>,
 #<Screw:0x007f86be46e0f0 id: 24, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86be47cf60 id: 25, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86be497d38 id: 26, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86be4a6ba8 id: 27, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86be4b59f0 id: 28, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>]
wheels[0].tyre
=> #<Tyre:0x007f86b8fb04c8 id: 23, type: "Tyre", created_at: Fri, 07 Apr 2017 04:53:33 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:33 UTC +00:00>
wheels[0].screws.count => 5
=> [#<Screw:0x007f86b833c750 id: 24, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86b833c570 id: 25, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86b833c3e0 id: 26, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86b833c250 id: 27, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>,
 #<Screw:0x007f86b833c0c0 id: 28, type: "Screw", created_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:53:49 UTC +00:00>]
wheels[1].tyre => nil
wheels[1].tyre = Tyre.create
=> #<Tyre:0x007f86bbb8e450 id: 29, type: "Tyre", created_at: Fri, 07 Apr 2017 04:58:05 UTC +00:00, updated_at: Fri, 07 Apr 2017 04:58:05 UTC +00:00>
wheels[1].item_children.count => 1
```

See, it's so easy to build model relations

## Advanced Usage

`acts_as_itemable` has following options:

- `sti`: `true` or `false`
- `children`: `true` or `false`
    - `true` generates association `item_children`, then support `has_many_items`
    - `false` does nothing
- `child`: `true` or `false`
    - `true` generates association `item_child`, then support `has_one_item`
    - `false` does nothing
- `parents`: `true` or `false`
    - `true` generates association `item_parents`, then support `belongs_to_items`
    - `false` does nothing
- `parent`: `true` or `false`
    - `true` generates association `item_parents`, then support `belongs_to_item`
    - `false` does nothing

options of `has_many_items`, `has_one_item`, `belongs_to_items`, `belongs_to_item` are the same to `has_many` or `belongs_to`

## Test

    rake

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
