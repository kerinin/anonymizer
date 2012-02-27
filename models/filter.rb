require 'mongoid'
require 'subject'

class Filter
  include Mongoid::Document

  field :search, type: String
  field :replace, type: String
  field :chunks, type: String
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
    query = Subject.where(:matched => {"$ne" => true}).where(:text => regex)
    {
      :results => query.limit(10).map{|subject| subject.text.match(regex)[index]}.uniq,
      :regex => regex.source,
      :total => query.count
    }
  end

  def get_options(index)
    map = "function(){
      match=this['text'].match(/#{regex.source}/)[#{index}];
      emit(match, {count: 1})
    }"
    reduce = "function(key, values){
      var result = {count: 0};
      values.forEach(function(value){result.count += value.count});
      return result;
    }"
    results = Subject.collection.map_reduce(
      map,
      reduce,
      :query => {:text => regex, :matched => {"$ne" => true}},
      :out => {:inline => 1},
      :raw => true
    )
    top_matches = results["results"].map do |i|
      {:key => i["_id"], :count => i["value"]["count"]}
    end.sort do |x,y|
      y[:count] <=> x[:count]
    end.map do |i|
      i[:key]
    end
    {
      :results => top_matches[0..10],
      :regex => regex.source,
      :total => query.count
    }
  end

  def redact(string)
    string.sub(regex, replace)
  end
end
