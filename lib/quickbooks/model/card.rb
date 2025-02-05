# frozen_string_literal: true

module Quickbooks
  module Model
    class Card < BaseModelJSON
      REST_RESOURCE = 'cards'

      attr_reader :raw_json_response

      attr_accessor :results

      xml_accessor(:id, from: 'Id')
      xml_accessor(:number, from: 'Number')
      xml_accessor(:exp_month, from: 'ExpMonth')
      xml_accessor(:exp_year, from: 'ExpYear')
      xml_accessor(:cvc, from: 'Cvc')
      xml_accessor(:updated, from: 'Updated', as: DateTime)
      xml_accessor(:card_type, from: 'CardType')
      xml_accessor(:name, from: 'Name')
      xml_accessor(:default?, from: 'Default')
      xml_accessor(:commercial_card_code, from: 'CommercialCardCode')
      # FIXME: xml_accessor(:address, from: 'Address', as: PhysicalAddress)
      xml_accessor(:is_business?, from: 'IsBusiness')
      xml_accessor(:is_level3_eligible?, from: 'IsLevel3Eligible')
      xml_accessor(:created, from: 'Created', as: DateTime)
      xml_accessor(:entity_type, from: 'EntityType')
      xml_accessor(:entity_id, from: 'EntityId')

      def initialize(options = {})
        @raw_json_response = options.delete(:json)

        if @raw_json_response&.plain_body.present?
          @results = JSON.parse(@raw_json_response.plain_body).map do |card|
            card.deep_transform_keys { |key| key.underscore.to_sym }
          end
        end

        super()
      end
    end
  end
end
