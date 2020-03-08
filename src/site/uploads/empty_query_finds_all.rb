# Modifies the innards of acts_as_solr so empty queries find every model instance
# instead of none, e.g. User.count_by_solr('') and Group.find_by_solr(nil).

module ActsAsSolr
  module FindAllExtension
    FIND_ALL_QUERY = 'type:[* TO *]'
    
    def self.included(mod)
      mod.alias_method_chain :parse_query, :find_all
    end

    def parse_query_with_find_all(query=nil, *args)
      query = query.blank? ? FIND_ALL_QUERY : query
      parse_query_without_find_all(query, *args)
    end

  end
end

module ActsAsSolr::ParserMethods
  include ActsAsSolr::FindAllExtension
end
