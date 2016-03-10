class User < ActiveRecord::Base
  has_many :comments
  has_many :commented_posts,
           :through => :comments,
           :source => :question

  has_many :authored_questions,
           :class_name => "Question",
           :foreign_key => "author_id"

end
