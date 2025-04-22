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
      def all(customer_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        model.from_json(response)
      end

      # Finds a specific card for a customer
      #
      # @param customer_id [Numeric, String]
      # @param card_id [Numeric, String]
      # @param request_id [String]
      #
      # @return [nil, Quickbooks::Model::Card, Hash]
      #
      def fetch_by_id(customer_id, card_id, request_id = nil)
        url = "#{url_for_payment_base}/customers/#{customer_id}/#{model::REST_RESOURCE}/#{card_id}"
        response = do_http_get(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        model.from_json(response)
      end

      # Creates a card under a customer
      #
      # @overload create(customer_id, attributes = {}, request_id = nil)
      #   @param customer_id [String, Numeric] Customer ID
      #   @param attributes [Hash] Card attributes
      #   @param request_id [String] Uniq request id
      #
      # @overload create(card, request_id = nil)
      #   @param card [Quickbooks::Model::Card]
      #   @param request_id [String] Uniq request id
      #
      # @return [Hash, nil, Quickbooks::Model::Card]
      #
      def create(customer_id, attributes = {}, request_id = nil)
        entity_id, req_attrs, req_id =
          if customer_id.is_a?(model)
            [customer_id.id, customer_id.to_json, attributes]
          else
            [customer_id, model.new(attributes).to_json, request_id]
          end

        url = "#{url_for_payment_base}/customers/#{entity_id}/#{model::REST_RESOURCE}"
        response = do_http_post(url, req_attrs, {}, { 'request-Id' => req_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        model.from_json(response)
      end

      # Deletes a card
      #
      # @param card [Quickbooks::Model::Card]
      # @param customer_id [String, Numeric] Customer ID
      # @param request_id [String] Uniq request id
      #
      # @return [Hash, nil, Boolean]
      #
      def delete(card, customer_id: nil, request_id: nil)
        cust_id = card.entity_id || customer_id
        url = "#{url_for_payment_base}/customers/#{cust_id}/#{model::REST_RESOURCE}/#{card.id}"
        response = do_http_delete(url, {}, { 'request-Id' => request_id || generate_uniq_request_id })

        return parse_intuit_error if response_is_error?

        return unless response&.code.to_i == 200

        true
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
