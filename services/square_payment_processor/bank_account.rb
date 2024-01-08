# frozen_string_literal: true

require 'square'
client = Square::Client.new(
  access_token: ENV.fetch('SQUARE_ACCESS_TOKEN'),
  environment: 'sandbox'
)

result = client.locations.list_locations

if result.success?
  result.data.locations.each do |loc|
    printf("%s: %s, %s, %s\n",
           loc[:id],
           loc[:name],
           loc[:address][:address_line_1],
           loc[:address][:locality])
  end
elsif result.error?
  result.errors.each do |error|
    warn error[:category]
    warn error[:code]
    warn error[:detail]
  end
end
def initialize(global_configuration)
  @global_configuration = global_configuration
  @config = @global_configuration.client_configuration
  @http_call_back = @config.http_callback
  @api_call = ApiCall.new(@global_configuration)
end
# Returns details of a [BankAccount]($m/BankAccount) linked to a Square account. the desired ‘BankAccount`.
#
# Parameters:
# bank_account_id (String) — Required parameter: Square-issued ID of
# Returns:
# (GetBankAccountResponse Hash) — response from the API call
module BankAccount
  class GetAccount
    def get_bank_account(bank_account_id:)
      new_api_call_builder
        .request(new_request_builder(HttpMethodEnum::GET,
                                     '/v2/bank-accounts/{bank_account_id}',
                                     'default')
                   .template_param(new_parameter(bank_account_id, key: 'bank_account_id')
                                     .should_encode(true))
                   .header_param(new_parameter('application/json', key: 'accept'))
                   .auth(Single.new('global')))
        .response(new_response_handler
                    .deserializer(APIHelper.method(:json_deserialize))
                    .is_api_response(true)
                    .convertor(ApiResponse.method(:create)))
        .execute
    end
  end

  class ListAccounts
    def list_bank_accounts(cursor: nil,
                           limit: nil,
                           location_id: nil)
      new_api_call_builder
        .request(new_request_builder(HttpMethodEnum::GET,
                                     '/v2/bank-accounts',
                                     'default')
                   .query_param(new_parameter(cursor, key: 'cursor'))
                   .query_param(new_parameter(limit, key: 'limit'))
                   .query_param(new_parameter(location_id, key: 'location_id'))
                   .header_param(new_parameter('application/json', key: 'accept'))
                   .auth(Single.new('global')))
        .response(new_response_handler
                    .deserializer(APIHelper.method(:json_deserialize))
                    .is_api_response(true)
                    .convertor(ApiResponse.method(:create)))
        .execute
    end
  end

end

