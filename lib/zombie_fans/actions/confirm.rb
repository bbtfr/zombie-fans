module ZombieFans::Actions
  module Confirm
    CONFIRMABLE_EMAIL = "%s@theoli.gq"

    def follow_confirm_link confirm_link
      agent.get(confirm_link) do |page|
        log_action 'FollowConfirmLink', "with login: #{login}, link: #{confirm_link}."
      end
    end

    def add_confirmable_email
      agent.get('https://github.com/settings/emails') do |page|
        confirmable_email = CONFIRMABLE_EMAIL % login
        log_action 'AddConfirmableEmail', "with login: #{login}, email: #{confirmable_email}"

        page = page.form_with(action: "/users/#{login}/emails") do |form|
          form['user_email[email]'] = confirmable_email
        end.submit

        if error = page.at('.flash.flash-error:not(.ajax-error-message)')
          log_error error.text.strip
        end
      end
    end

    def set_email_private
      agent.get('https://github.com/settings/emails') do |page|
        log_action 'ToggleEmailVisibility', "with login: #{login}, visibility: #{false}"

        page = page.form_with(action: "/users/#{login}/emails/toggle_visibility") do |form|
          form['toggle_visibility'] = 'false'
        end.submit

        if error = page.at('.flash.flash-error:not(.ajax-error-message)')
          log_error error.text.strip
        end
      end
    end

  end
end
