module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mappings do
      indexes :user_id, type: 'integer'
      indexes :title, type: 'text' do
        indexes :keyword, type: 'keyword'
      end
      indexes :description, type: 'text' do
        indexes :keyword, type: 'keyword'
      end
    end

    def self.search(args, user_id=nil)
      if args[:query].present?
        query = {
          bool: {
            must: [
              {
                multi_match: {
                  query: args[:query],
                  fields: ['title', 'description'],
                  fuzziness: "AUTO"
                }
              }
            ]
          }
        }
      else
        query = {
          bool: {
            must: [
              {
                match_all: {}
              }
            ]
          }
        }
      end

      if user_id.present?
        query[:bool][:must] << { term: { user_id: user_id } }
      end

      page = args[:page].present? ? args[:page].to_i : 1
      per_page = args[:per_page].present? ? args[:per_page].to_i : 10

      params = {
        from: ((page-1) * per_page),
        size: per_page,
        sort: [],
        query: query
      }

      if args[:sort_by]
        sort_hash = {}
        sort_by = "#{args[:sort_by]}.keyword"
        sort_hash[sort_by] = { order: args[:sort_order] || 'asc'}
        params[:sort] << sort_hash
      end

      self.__elasticsearch__.search(params).records.to_a
    end
  end
end
