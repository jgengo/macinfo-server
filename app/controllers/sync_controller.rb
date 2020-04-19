class SyncController < ApplicationController

    def create 
        @client = Client.find_by(hostname: params[:hostname])
        
        if @client
            return render json: {"error": "forbidden"}, status: 403 unless @client.token == params[:token]

            
            os = Os.where(version: params[:os_version][:version], build: params[:os_version][:build]).first_or_create!
            
            @client.update(os_id: os.id)                            unless @client.os_id == os.id
            @client.update(uptime: params[:uptime])                 if @client.uptime != params[:uptime]
            @client.update(active_user: params[:active_user])       if @client.active_user != params[:active_user]
            @client.update(uuid: params[:uuid])                     if @client.uuid != params[:uuid]

            params[:sensors].each do |sensor|
                @sensor = Sensor.where(name: sensor['name']).first_or_create!

                cs = ClientsSensor.create!(sensor_id: @sensor.id, client_id: @client.id, celsius: sensor['celsius'])
            end


            return render json: {}, status: 200
        else
            @client = Client.create!(hostname: params[:hostname])
            return render json: {"token": @client.token}, status: 201
        end
    end

end
