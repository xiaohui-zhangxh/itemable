$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "itemable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "itemable"
  s.version     = Itemable::VERSION
  s.authors     = ["xiaohui"]
  s.email       = ["xiaohui@zhangxh.net"]
  s.homepage    = "http://github.com/xiaohui-zhangxh/itemable"
  s.summary     = "Make your ActiveRecord model to be an item, has polymorphic children and parents."
  s.description = "Make your ActiveRecord model to be an item, has polymorphic children and parents."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "rails", ">= 4.2"

  s.add_development_dependency "sqlite3"
end
