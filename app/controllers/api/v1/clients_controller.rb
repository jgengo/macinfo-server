class Api::V1::ClientsController < ApplicationController
    before_action :check_token

    def index
        @clients = Client.all
        render json: @clients, status: 200
    end

    def show 
        @client = Client.find_by_id(params[:id])
        if @client.nil?
            render json: {}, status: 404
        else
            render json: @client, status: 200
        end
    end

    private

    def check_token
        render json: {error: "Unauthorized"}, status: 401 unless params[:token] == 'abcdef'
    end
end
