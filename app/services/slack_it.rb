class SlackIt

    def initialize
        @uri =  URI(ENV["SLACK_WEBHOOK_URL"])
    end

    def report(message)
        params = {
            attachments: [
                {
                    fallback: "MacInfo report",
                    color: "warning",
                    fields: [
                        {
                            title: "MacInfo report",
                            value: message,
                        }
                    ]
                }
            ]
        }
        @params = { payload: params.to_json }
        self
    end

    def deliver
        begin
            Net::HTTP.post_form(@uri, @params)
        rescue => e
            Rails.logger.error("SlackIt: Error when sending: #{e.message}")
        end
    end

end