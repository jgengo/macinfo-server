class Api::V1::DevicesController < ApplicationController
    before_action :check_token

    def index
    	@client = Client.find_by_id(params[:client_id])
        if @client.nil?
            render json: {error: "Not found"}, status: 404
            return
        end
    	@devices = Device.last_sync(@client)


    	render json: @devices, status: 200
    end

	private 

    def check_token
        render json: {error: "Unauthorized"}, status: 401 unless params[:token] == 'abcdef'
    end
end
