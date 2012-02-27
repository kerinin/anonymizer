require "mongoid"

class Subject
  include Mongoid::Document
  
  field :text, :type => String
  field :matched, :type => Boolean, :default => false
  field :rand, :type => Float
  index :matched
  index :rand
end
