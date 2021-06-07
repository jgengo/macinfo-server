namespace :weekly_report do

  require 'slack-notifier'

  task :slack_cluster_usage => :environment do |t|
    week = (Time.zone.now - 7.days).beginning_of_day
    previous_week = week- 7.days

    prev_loc = Location.where('begin_at > ? and begin_at < ?', previous_week, week)
    loc = Location.where('begin_at > ?', week)

    prev_uniq_loc = prev_loc.pluck(:user).uniq.count
    uniq_loc = loc.pluck(:user).uniq.count

    loc_time = loc.map { |x| x.end_at - x.begin_at unless x.end_at.nil? }.compact
    loc_sum = loc_time.reduce(0) { |a, v| a+v }
    loc_avg = Time.at(loc_sum / loc_time.count).utc.strftime("%H:%M:%S")

    pct_inc = (uniq_loc - prev_uniq_loc) / prev_uniq_loc.to_f * 100

    top = loc.group(:user).count.sort_by { |_, v| v }.reverse

    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'], channel: "#testing2", username: "macInfo"
    clock = ":clock:#{Time.at(loc_sum/loc_time.count).utc.strftime("%k")}:"
    blocks = [
      { "type": "header", "text": { "type": "plain_text", "text": "Cluster usage last week", "emoji": true } },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": ":busts_in_silhouette: *#{uniq_loc}* students connected (*#{sprintf("%+d", pct_inc)}%* compare to previous week)"
        }
      },
      { "type": "section", "text": { "type": "mrkdwn", "text": "#{clock} Average location duration last week is *#{loc_avg}*" } },
      { "type": "header", "text": { "type": "plain_text", "text": "Most active students last week", "emoji": true } },
      {
        "type": "context",
        "elements": [
          { "type": "image", "image_url": "https://cdn.intra.42.fr/users/small_#{top[0][0]}.jpg", "alt_text": "pic" },
          { "type": "mrkdwn", "text": ":first_place_medal: *#{top[0][0]}* with #{top[0][1]} locations" }
        ]
      },
      {
        "type": "context",
        "elements": [
          { "type": "image", "image_url": "https://cdn.intra.42.fr/users/small_#{top[1][0]}.jpg", "alt_text": "pic" },
          { "type": "mrkdwn", "text": ":second_place_medal: *#{top[1][0]}* with #{top[1][1]} locations"}
        ]
      },
      {
        "type": "context",
        "elements": [
          { "type": "image", "image_url": "https://cdn.intra.42.fr/users/small_#{top[2][0]}.jpg", "alt_text": "pic" },
          { "type": "mrkdwn","text": ":third_place_medal: *#{top[2][0]}* with #{top[2][1]} locations" }
        ]
      }
    ]

    notifier.post(blocks: blocks)
  end
end
