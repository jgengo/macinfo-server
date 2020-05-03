set :output, "/tmp/cron_log.log"

ENV.each { |k, v| env(k, v) }

every 2.minute do
  runner "Sync.push_to_influxdb"
end