# frozen_string_literal: true

module Quickbooks
  module Service
    class Card < BaseServiceJSON
      def query(object_query = nil, options = {}, params = {}, headers = {})
        headers['request-Id'] ||= generate_uniq_request_id

        fetch_collection(object_query, model, options, params, headers)
      end

      private

        def model
          Quickbooks::Model::Card
        end

        def generate_uniq_request_id
          SecureRandom.uuid
        end
    end
  end
end
