module Quickbooks
  module Model
    class Report < BaseModelJSON

      attr_accessor :json

      attr_reader :columns
      attr_reader :errors
      attr_reader :headers
      attr_reader :response_attributes
      attr_reader :rows

      def initialize(options = {})
        @json = options.dig(:json)
        @response_attributes = {}

        begin
          @response_attributes = JSON.parse(options[:json]).deep_transform_keys { |key| key.underscore.to_sym }

          @headers = @response_attributes.fetch(:header, {})
          @columns = @response_attributes.dig(:columns).fetch(:column, [])
          @rows = @response_attributes.dig(:rows).fetch(:row, [])
          @errors = @response_attributes.dig(:fault, :error) || []
        rescue => e
          @errors = [{ message: e.message, detail: nil, code: nil, element: nil }]
        end

        super
      end

      # @return [Hash, nil]
      def attributes
        @response_attributes
      end

      # @return [Array, nil]
      def attribute_names
        @response_attributes&.keys
      end

      # @return [String]
      def to_json
        @response_attributes.to_json
      end

      # Parses and formats the row data if no errors.
      #
      # @param style [String] Supported options: 'array' & 'hash'
      #   Defaults to 'array' to keep backwards compatibility.
      #
      # @return [Array]
      #
      def all_rows(style: 'array')
        return [] if @rows.nil? || @headers.nil?

        return [] if !@errors.nil? && !@errors.empty?

        return zip_rows if style.to_s == 'array'

        zip_rows_as_hash
      end

      # @deprecated No longer supported with JSON response objects
      def find_row(_label)
        raise(NotImplementedError, "`find_row` is no longer supported")
      end

      private

      def parse_row_value(value)
        # does it look like a number?
        if value =~ /\A-?[0-9.]+\Z/
          BigDecimal(value)
        else
          value
        end
      rescue ArgumentError
        value
      end

      # Merges row columns with the corresponding headers,
      # assigns indexes for both the row and column,
      # and will transform column header names to remove `col_`
      # from the key name.
      #
      # @return [Array<Array>]
      #
      def zip_rows
        @zip_rows ||=
          @rows.map.with_index do |row, idx|
            row_data = row.fetch(:col_data, []).dup

            next nil if row_data.empty?

            row_data.each_with_index do |col_data, col_idx|
              col_data[:row_index] = idx
              col_data[:index] = col_idx
              col_data[:value] = parse_row_value(col_data[:value])
            end

            @columns.each_with_index do |column, col_idx|
              next if row_data[col_idx].nil?

              row_data[col_idx].merge!(column.transform_keys { |col_key| col_key.to_s.tr('col_', '').to_sym })
            end

            row_data
          end
      end

      # Does the same thing as
      # @see {#zip_rows}
      # but will convert each row to a hash with the row
      # index and columns as keys.
      #
      # @return [Array<Hash>]
      #
      def zip_rows_as_hash
        @zip_rows_as_hash ||=
          zip_rows.map.with_index do |row, idx|
            {
              index: idx,
              columns: row
            }
          end
      end
    end
  end
end
