require 'zombie_fans'

puts "=== #{Time.now} ==="
robot = ZombieFans::Robot.new
robot.sign_up
robot.upload_avatar
robot.update_profile
robot.star_repo "bbtfr/zombie-fans"
