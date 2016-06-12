module ZombieFans::Actions
  module User
    def update_profile
      agent.get('https://github.com/settings/profile') do |page|
        page.form_with(action: "/users/#{login}") do |form|
          name = sample_display_name
          blog = sample_result Faker::Internet.url, 2
          company = sample_result Faker::Company.name
          location = Faker::Address.city

          log_action 'UpdateProfile', "with name: #{name}, blog: #{blog || 'nil'}, company: #{company || 'nil'}, location: #{location || 'nil'}."

          form['user[profile_name]'] = name
          form['user[profile_blog]'] = blog
          form['user[profile_company]'] = company
          form['user[profile_location]'] = location
        end.submit
      end
    end

    def follow_user user
      page = agent.get("https://github.com/#{user}")
      form = page.at('.user-following-container:not(.on) .follow form')
      return unless form

      log_action 'FollowUser', "#{user}."

      authenticity_token = form.at('input[name=authenticity_token]').attr('value')
      follow_user_url = form.attr('action')

      query = {
        authenticity_token: authenticity_token
      }

      header = {
        'X-Requested-With' => 'XMLHttpRequest'
      }

      # agent.agent.allowed_error_codes = [400]
      page = agent.post(follow_user_url, query, header)
      response = JSON.parse page.body
    end

  private

    def sample_display_name
      names = name.split(' ')
      names = [names.join('-').downcase, names.first.downcase, names.last.downcase, name, name, name, name, name, names.first, names.last].sample
    end

    def sample_result result, weight = 1
      ([nil] * weight + [result]).sample
    end
  end
end
