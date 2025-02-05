# frozen_string_literal: true

module Quickbooks
  module Service
    class Card < BaseServiceJSON
      # Finds all cards for a given customer
      # @see https://developer.intuit.com/app/developer/qbpayments/docs/api/resources/all-entities/cards#get-a-list-of-cards-for-a-specific-customer
      #
      # @param customer_id [Numeric, String]
      # @param request_id [String]
      #
      # @return [nil, Quickbooks::Model::Card]
      #
      def list(customer_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return unless response&.code.to_i == 200

        model.new({ json: response })
      end

      private

        # @return [Class<Quickbooks::Model::Card>]
        def model
          Quickbooks::Model::Card
        end

        # @return [String] Unique request id
        def generate_uniq_request_id
          SecureRandom.uuid
        end
    end
  end
end
