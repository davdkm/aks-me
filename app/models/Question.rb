class Question < ActiveRecord::Base
  belongs_to :author,
             :class_name => "User"
             
  has_many :comments
  has_many :commeters,
           :through => :comments,
           :source => :commenter
end
