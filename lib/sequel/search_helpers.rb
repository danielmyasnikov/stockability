module Sequel
  module SearchHelpers

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def smart_search(search_params)
        where(smart_query(search_params))
      end

      def smart_query(search_params)
        search_params = normalize_params(search_params)

        query = []
        search_params.each do |k, v|
          query << compose_query(k, v)
        end
        query.join(' AND ')
      end

      def compose_query(key, value)
        query = []
        if value.kind_of?(Array)
          value.each do |val|
            query << compose_comparison(key, val)
          end
        else
          query << compose_comparison(key, value)
        end
        query.join(' OR ')
      end

      def compose_comparison(key, value)
        case
        when value.match(/\*|\?|\_|\%/)
          value = value.gsub("\*", '%').gsub("\?", "_")
          value = "like '#{value}'"
        else
          value = "= '#{value}'"
        end

        return "#{key} #{value}"
      end

      def normalize_params(params)
        params.delete_if { |k, v| v.empty? }
        params.each { |k, v| params[k] = v.split(',') }
      end
    end
  end
end
