module Slugifiable
  extend ActiveSupport::Concern

  def slug
    self.username.gsub(/(\s|\W)/, "-").downcase
  end


  module ClassMethods
    def find_by_slug(slug)
      self.all.detect{|a| a.slug == slug}
    end
  end

  class ActiveRecord::Base
    include Slugifiable
  end
end
