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

      def attributes
        @response_attributes
      end

      def attribute_names
        @response_attributes.keys
      end

      def to_json
        @response_attributes.to_json
      end

      def all_rows(style: 'array', headers: true)
        return zip_rows if style.to_s == 'array'

        zip_rows_as_hash(headers: headers)
      end

      def find_row(label)
        all_rows.find { |row| row[:col_title] == label }
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

      def zip_rows
        return [] if @rows.nil? || @headers.nil?

        return [] if !@errors.nil? && !@errors.empty?

        @zip_rows ||=
          @rows.map.with_index do |row, idx|
            row_data = row.fetch(:col_data, [])

            next nil if row_data.empty?

            row_data.each do |col_data|
              col_data[:row_index] = idx
              col_data[:value] = parse_row_value(col_data[:value])
            end

            @columns.each_with_index do |column, col_idx|
              next if row_data[col_idx].nil?

              row_data[col_idx].merge!(column)
            end

            row_data
          end
      end

      def zip_rows_as_hash(headers: true)
        return [] if @rows.nil? || @headers.nil?

        return [] if !@errors.nil? && !@errors.empty?

        @zip_rows_as_hash ||=
          @rows.map.with_index do |row, idx|
            row_data = row.fetch(:col_data, [])

            next nil if row_data.empty?

            row_data.each_with_index do |col_data, col_idx|
              col_data[:index] = col_idx
              col_data[:value] = parse_row_value(col_data[:value])
            end

            if headers
              @columns.each_with_index do |column, col_idx|
                next if row_data[col_idx].nil?

                row_data[col_idx].merge!(column)
              end
            end

            {
              index: idx,
              columns: row_data
            }
          end
      end
    end
  end
end
