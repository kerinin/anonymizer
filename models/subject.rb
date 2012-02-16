require "mongoid"

class Subject
  include Mongoid::Document
  
  field :text, :type => String
end

