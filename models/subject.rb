require "mongoid"

class Subject
  include Mongoid::Document
  
  field :text, :type => String
  field :matched, :type => Boolean, :default => false
end
