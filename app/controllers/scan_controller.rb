class ScanController < ApplicationController
  def show
    @policy_id = params[:policy_id]

    @options = default_options.merge({ policy_id: @policy_id })


    @response  = ScanService.new(@options).call
  end

  protected

  def default_options
    { api_key: ENV['CARDASCAN_API_KEY'], project_id: ENV['BLOCKFROST_API_KEY'] }
  end
end
