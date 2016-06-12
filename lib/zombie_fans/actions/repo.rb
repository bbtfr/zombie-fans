module ZombieFans::Actions
  module Repo
    def create_repo
      agent.get('https://github.com/new') do |page|
        page.form_with(action: '/repositories') do |form|
          name = Faker::Internet.domain_word
          description = Faker::Hacker.say_something_smart
          @repos ||= []
          @repos << name

          log_action 'CreateRepo', "with name: #{name}, description: #{description}."

          form['repository[name]'] = name
          form['repository[description]'] = description
        end.submit

        save
      end
    end

    def star_repo repo
      page = agent.get("https://github.com/#{repo}")
      form = page.at('.starring-container:not(.on) form.unstarred')
      return unless form

      log_action 'StarRepo', "#{repo}."

      authenticity_token = form.at('input[name=authenticity_token]').attr('value')
      star_repo_url = form.attr('action')

      query = {
        authenticity_token: authenticity_token
      }

      header = {
        'X-Requested-With' => 'XMLHttpRequest'
      }

      # agent.agent.allowed_error_codes = [400]
      page = agent.post(star_repo_url, query, header)
      response = JSON.parse page.body
    end
  end
end
