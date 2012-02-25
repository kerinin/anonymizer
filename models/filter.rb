require 'mongoid'
require 'subject'

class Filter
  include Mongoid::Document

  field :search, type: String
  field :replace, type: String
  index :search
  index :replace

  def regex
    Regexp.new search
  end

  def test_results
    query = Subject.where(:matched => false).where(:text => regex)
    {
      :results => query.limit(30).map {|subject| {:raw => subject.text, :redacted => redact(subject.text)} }, 
      :regex => regex.source,
      :replace => replace,
      :total => query.count
    }
  end

  def get_matches(index)
    query = Subject.where(:text => regex)
    #query = Subject.where(:matched => false).where(:text => regex)
    {
      :results => query.limit(10).map{|subject| subject.text.match(regex)[index]}.uniq,
      :regex => regex.source,
      :total => query.count
    }
  end

  def redact(string)
    string.sub(regex, replace)
  end
end
