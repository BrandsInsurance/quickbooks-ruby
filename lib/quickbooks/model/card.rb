# frozen_string_literal: true

module Quickbooks
  module Model
    class Card < BaseModelJSON
      REST_RESOURCE = 'cards'

      Address = Struct.new(:street_address, :city, :postal_code, :region, :country, keyword_init: true)

      CvcVerification = Struct.new(:result, :date, keyword_init: true)

      ZeroDollarVerification = Struct.new(:status, keyword_init: true)

      KEY_CLASS_MAPPINGS = {
        address: 'Quickbooks::Model::Card::Address',
        cvc_verification: 'Quickbooks::Model::Card::CvcVerification',
        zero_dollar_verification: 'Quickbooks::Model::Card::ZeroDollarVerification'
      }.freeze

      # @return [String] Card ID
      attr_accessor :id

      # @return [String] Redacted card number (last 4 with leading "x"'s)
      attr_accessor :number

      # @return [String] Name on the card
      attr_accessor :name

      # @return [Address] Address hash associated to the card
      attr_accessor :address

      # @return [DateTime] When the card was created
      attr_accessor :created

      # @return [DateTime] When the card was lasted updated
      attr_accessor :updated

      # @return [Integer] Card version
      attr_accessor :entity_version

      # @return [CvcVerification] CVC verification info
      attr_accessor :cvc_verification

      # @return [String] Card type ('visa', 'mc', etc.)
      attr_accessor :card_type

      # @return [Integer] ID of the base entity (not the card)
      attr_accessor :entity_id

      # @return [String] Type of entity ('customers', 'vendors', etc.)
      attr_accessor :entity_type

      # @return [String] SHA512 number field
      attr_accessor :number_sha512

      # @return [String] Card status
      attr_accessor :status

      # @return [ZeroDollarVerification]
      attr_accessor :zero_dollar_verification

      # @return [Integer] Expiration month
      attr_accessor :exp_month

      # @return [Integer] Expiration year
      attr_accessor :exp_year

      # @return [Boolean] If the card is set as the default
      attr_accessor :default

      # @return [Boolean] If the card is marked as business only
      attr_accessor :is_business

      # @return [Boolean] Card falls into the L3 eligible Bank Identification Number (BIN) range
      attr_accessor :is_level3_eligible

      # @return [Hash] Initial options
      attr_accessor :options

      class << self
        # Parse the json response
        #
        # @param response
        #
        # @return [nil, Array<Quickbooks::Model::Card>, Quickbooks::Model::Card]
        #
        def from_json(response = nil)
          return if response&.plain_body.blank?

          json = JSON.parse(response.plain_body)

          if json.is_a?(Array)
            return json.map do |card|
              Quickbooks::Model::Card.new(card.deep_transform_keys { |key| key.underscore.to_sym })
            end
          end

          Quickbooks::Model::Card.new(json.deep_transform_keys { |key| key.underscore.to_sym })
        end
      end

      def initialize(options = {})
        @options = options || {}

        init_map_fields(@options)

        super()
      end

      private

        # Sets the initial values
        #
        # @param options [Hash]
        #
        # @return [void]
        #
        def init_map_fields(options)
          options.each do |key, value|
            if KEY_CLASS_MAPPINGS.has_key?(key)
              public_send("#{key}=", KEY_CLASS_MAPPINGS[key].constantize.new(**value))

              next
            end

            next unless respond_to?(key)

            public_send("#{key}=", value)
          end
        end
    end
  end
end
