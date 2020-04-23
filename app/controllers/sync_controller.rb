class SyncController < ApplicationController

    def create 
        @client = Client.find_by(hostname: params[:hostname])
        
        if @client
            return render json: {"error": "forbidden"}, status: 403 unless @client.token == params[:token]

            @client.sync_save(params)

            return render json: {}, status: 200
        else
            @client = Client.create!(hostname: params[:hostname], uuid: params[:uuid])
            return render json: {"token": @client.token}, status: 201
        end
    end

end
