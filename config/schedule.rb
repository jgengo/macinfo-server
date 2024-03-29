set :output, "/tmp/cron_log.log"

ENV.each { |k, v| env(k, v) }

every 2.minute do
  runner "Sync.push_to_influxdb"
end

every 1.day, at: '4:30 am' do
  runner "Sync.delete_old_entries"
  runner "ClientsDevice.delete_old_entries"
end

every :monday, at: "9:00 am" do
  rake "weekly_report:slack_cluster_usage"
end
