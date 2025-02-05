# frozen_string_literal: true

module Quickbooks
  module Model
    class Card < BaseModelJSON
      REST_RESOURCE = 'cards'

      attr_reader :raw_json_response

      attr_accessor :results

      def initialize(options = {})
        @raw_json_response = options.delete(:json)

        if @raw_json_response&.plain_body.present?
          @results = JSON.parse(@raw_json_response.plain_body).map do |card|
            card.deep_transform_keys { |key| key.underscore.to_sym }
          end
        end

        super(options)
      end
    end
  end
end
