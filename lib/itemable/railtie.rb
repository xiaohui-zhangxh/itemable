module Itemable
  class Railtie < Rails::Railtie
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::Base.send :include, Itemable::ActsAsItemable
    end
  end
end
