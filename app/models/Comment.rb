class Comment < ActiveRecord::Base
  belongs_to :commenter,
             :class_name => "User",
             :foreign_key => "user_id"

  belongs_to :question
  self.per_page = 10
end
