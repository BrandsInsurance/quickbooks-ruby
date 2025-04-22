# frozen_string_literal: true

module Quickbooks
  module Service
    class Card < BaseServiceJSON
      # Finds all cards for a given customer
      #
      # @param customer_id [Numeric, String]
      # @param request_id [String]
      #
      # @return [nil, Array<Quickbooks::Model::Card>, Hash]
      #
      def list(customer_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        model.from_json(response)
      end

      # Finds a specific card
      #
      # @param customer_id [Numeric, String]
      # @param card_id [Numeric, String]
      # @param request_id [String]
      #
      # @return [nil, Quickbooks::Model::Card, Hash]
      #
      def find_by_id(customer_id, card_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}/#{card_id}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        model.from_json(response)
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
