class Client < ApplicationRecord
    has_many :infos
    has_one :os

    def show
        @client = Client.find_by(hostname: params[:hostname])
        render json: {error: "client not found"}.to_json, status: 400 unless @client

    end
end
