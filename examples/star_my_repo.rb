require 'zombie_fans'

repos = %w(bbtfr/tailog bbtfr/tailog bbtfr/evil-proxy bbtfr/zombie-fans)

puts nil, "=== #{Time.now} ===".colorize(:blue)
robot = ZombieFans::Robot.new
robot.sign_up
robot.upload_avatar
robot.update_profile

robot.star_repo repos.sample
robot.follow_user 'bbtfr'
