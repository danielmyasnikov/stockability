module Requests
  module JsonHelpers
    def parsed_json
      @arr_json ||= JSON.parse(response.body)
    end

    def json
      @json ||= HashWithIndifferentAccess.new JSON.parse(response.body)
    end

    def json_arr
      @json_arr ||= JSON.parse(response.body).each do |resp_hash|
        HashWithIndifferentAccess.new resp_hash
      end
    end
  end
end
