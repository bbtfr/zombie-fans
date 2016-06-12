# ZombieFans

Create github zombie fans to follow you / star your repo.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zombie_fans'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zombie_fans

## Usage

```ruby

robot = ZombieFans::Robot.new # create a robot

robot.sign_up # sign up with random login, email & password, these will be saved in db/zombie_fans.yml
robot.upload_avatar # upload random avatar
robot.update_profile # fill profile form with random company name & city name

# or you can use an existed account in db/zombie_fans.yml
robot = ZombieFans::Robot.find('username') # find user by username
robot = ZombieFans::Robot.sample # random pick an existed account

robot.sign_in # sign in

robot.star_repo 'bbtfr/zombie-fans' # star a repo
robot.follow_user 'bbtfr' # follow an user
```

You can find more examples [here](https://github.com/bbtfr/zombie-fans/tree/master/examples).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bbtfr/zombie_fans. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

