require 'faker'

module ZombieFans::Actions
  module Auth
    def sign_up
      agent.get('https://github.com/join') do |page|
        retry_register = true
        while retry_register
          page = fill_signup_page page
          error_messages = page.search('.form-group.errored .error').map(&:text)
          retry_register = error_messages.any?
          log_error error_messages.join(', ').downcase if retry_register
        end
        save
      end
    end

    def sign_in
      agent.get('https://github.com/settings/profile') do |page|
        log_action 'SignIn', "with login: #{login}, email: #{email}, password: #{password}."

        page.form_with(action: '/session') do |form|
          form['login'] = @login
          form['password'] = @password
        end.submit
      end
    end

    private

      def sample_login
        names = name.split(' ')
        [names.join('-'), names.join('-'), names.join('-'), names.first, names.last, name[0] + names.last, name[0..1] + '-' + names.last].sample.downcase
      end

      def fill_signup_page page
        page.form_with(action: '/join') do |form|
          @name = Faker::Name.name
          @login = sample_login
          @email = Faker::Internet.free_email sample_login
          @password = Faker::Internet.password(7, 20, true)

          log_action 'SignUp', "with login: #{login}, password: #{password}."

          form['user[login]'] = @login
          form['user[email]'] = @email
          form['user[password]'] = @password
        end.submit
      end

  end
end
