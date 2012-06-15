class Book < ActiveRecord::Base
  attr_accessible :id, :title, :author, :available
end