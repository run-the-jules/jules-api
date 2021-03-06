class Api::V1::GetMetersController < ApplicationController
  def index
    if params[:referral].to_i != 0
      @meters = MeterActivationFacade.referral(params)
      if @meters == nil
        @skip_after_action = true
        something_went_wrong
      else
        spawnling
        render( json: {data: "Your Meters have been pulled and bills are being generated, please check back in 15 minutes."})
      end
    else
      @skip_after_action = true
      raise_not_found!
    end
  end

  private

  def spawnling 
    Spawnling.new do
      get_bills(params[:id]) unless @skip_after_action
    end
  end

  def get_bills(id)
    bills = MeterActivationFacade.parse_meters(@meters, id)
    if bills.nil? || bills.first.nil?
      sleep 5.minutes
      get_bills(id)
    end
  end
end
