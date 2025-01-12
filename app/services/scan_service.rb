class ScanService
  def initialize(options = {})
    raise "policy_id or token_id is required" if options[:policy_id].nil? && options[:token_id].nil?
    @options = options
  end

  def call
    # we find out the token id if policy_id exists
    if @options[:policy_id].present?
      tokens = AdaService.new(:fetch_asset_list_by_policy_id, @options).call
      @options[:asset_id] = tokens[0]['assetId']
    end

    @token_details = AdaService.new(:fetch_token_details, @options).call
    @transactions = AdaService.new(:fetch_latest_transactions, @options).call
    @options[:tx_id] = @token_details['initial_mint_tx_hash']
    @first_transaction = AdaService.new(:fetch_transaction_details, @options).call

    { details: @token_details, transactions: @transactions, first_tx: @first_transaction }
  end
end
