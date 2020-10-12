class SyncController < ApplicationController

    def create 
        @client = Client.find_by(hostname: params[:hostname])
        
        Sync.create!(hostname: params[:hostname], data: params)

        if @client
            if @client.token == ""
                @client.regenerate_token
                return render json: {"token": @client.token}, status: 201
            end

            return render json: {"error": "forbidden"}, status: 403 unless @client.token == params[:token]

            return render json: {}, status: 200
        else
            @client = Client.create!(hostname: params[:hostname], uuid: params[:uuid])
            return render json: {"token": @client.token}, status: 201
        end
    end

end
