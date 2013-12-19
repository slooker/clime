class Collection < ActiveRecord::Base
  attr_accessible :content, :name, :slug, :id
  has_many :tags
end
