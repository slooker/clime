class Tag < ActiveRecord::Base
  attr_accessible :name, :slug, :category, :id
  belongs_to :collection
end
