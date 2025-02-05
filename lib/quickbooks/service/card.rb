# frozen_string_literal: true

module Quickbooks
  module Service
    class Card < BaseServiceJSON
      def query(customer_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return unless response&.code.to_i == 200

        model.new({ json: response })
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
