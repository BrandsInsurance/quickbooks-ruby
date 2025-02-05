# frozen_string_literal: true

module Quickbooks
  module Service
    class Card < BaseServiceJSON
      REST_RESOURCE = 'cards'

      # def query(object_query = nil, options = {}, params = {}, headers = {})
      #   headers['request-Id'] ||= generate_uniq_request_id
      #
      #   fetch_collection(object_query, model, options, params, headers)
      # end
      def query(customer_id, request_id = nil)
        url = "#{url_for_payment_base}/customer/#{customer_id}/cards"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return unless response&.code.to_i == 200

        response
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
