module Quickbooks
  module Service
    class Account < BaseService

      def delete(account)
        account.active = false
        update(account, :sparse => true)
      end

      # Pulls account by id
      # @see https://developer.intuit.com/app/developer/qbo/docs/api/accounting/most-commonly-used/account#read-an-account
      #
      # @param id [Numeric, String] Quickbooks account id
      # @param params [Hash] Extra params with the request
      #
      # @return [Quickbooks::Model::Account, nil]
      #
      def fetch_by_id(id, params = {})
        url = "#{url_for_base}/account/#{id}"
        fetch_object(model, url, params)
      end

      private

      def model
        Quickbooks::Model::Account
      end
    end
  end
end
