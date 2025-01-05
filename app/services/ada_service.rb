require 'httparty'
class AdaService
  # Services to connect to Cardano chain
  # - Cardanoscan
  # - BlockFrost
  def initialize(endpoint, options = {})
    @endpoint = endpoint.to_s.downcase
    raise "no endpoint named #{endpoint}" unless endpoints.include?(@endpoint)
    @options = options
  end

  def call
    send(@endpoint.to_sym)
  end

  protected

  def fetch_asset_list_by_policy_id
    @options[:page_no] ||= 1
    url = "https://api.cardanoscan.io/api/v1/asset/list/byPolicyId?policyId=#{@options[:policy_id]}&pageNo=#{@options[:page_no]}"
    # Send GET request to the API
    Rails.cache.fetch("tokens-#{@options[:policy_id]}-#{@options[:page_no]}", expires_in: 24.hours) do
      response = HTTParty.get(url, headers: { "apiKey" => @options[:api_key]})
      # Parse and handle the response
      if response.code == 200
        JSON.parse(response.body)["tokens"] || []
      else
        JSON.parse(response.body) || { error: :no_body }
      end
    end
  end

  def fetch_token_details
    url = "https://cardano-mainnet.blockfrost.io/api/v0/assets/#{@options[:asset_id]}"
    Rails.cache.fetch("token-#{@options[:asset_id]}", expires_in: 24.hours) do
      response = HTTParty.get(url, headers: { "project_id" => @options[:project_id] })
      JSON.parse(response.body) || []
    end
  end

  # Fetch the latest transactions from Blockfrost
  def fetch_latest_transactions
    url = "https://cardano-mainnet.blockfrost.io/api/v0/assets/#{@options[:token_id]}/transactions?count=10&order=asc"
    Rails.cache.fetch("txs-#{@options[:token_id]}", expires_in: 24.hours) do
      response = HTTParty.get(url, headers: { "project_id" => @options[:project_id]})
      JSON.parse(response.body) || []
    end
  end

  def fetch_transaction_details
    url = "https://api.cardanoscan.io/api/v1/transaction?hash=#{@options[:tx_id]}"
    Rails.cache.fetch("tx-#{@options[:tx_id]}") do
      response = HTTParty.get(url, headers: { "apiKey" => options[:api_key]})
      JSON.parse(response.body) || []
    end
  end

  def endpoints
    %w(fetch_asset_list_by_policy_id fetch_token_details fetch_latest_transactions fetch_transaction_details)
  end
end
