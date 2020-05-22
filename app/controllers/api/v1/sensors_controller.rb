class Api::V1::SensorsController < ApplicationController
    before_action :check_token

    def index
    	@client = Client.find_by_id(params[:client_id])
        if @client.nil?
            render json: {error: "Not found"}, status: 404
            return
        end

    	@sensors = @client.sensors.where('clients_sensors.created_at > ?', Time.zone.now - 1.minutes).select(:name, :celsius).as_json(except: :id)

    	render json: @sensors, status: 200
    end

	private 

    def check_token
        render json: {error: "Unauthorized"}, status: 401 unless params[:token] == 'abcdef'
    end
end

