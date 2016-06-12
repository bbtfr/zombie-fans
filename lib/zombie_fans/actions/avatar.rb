module ZombieFans::Actions
  module Avatar
    def upload_avatar
      page = agent.get('http://randomavatar.com')
      avatar_url = page.at('.RAFade').attr('src')

      log_action 'UploadAvatar', "with #{avatar_url}."

      page = agent.get('https://github.com/settings/profile')
      form = page.at('form.js-upload-avatar-image')
      owner_id = form.attr('data-alambic-owner-id')
      owner_type = form.attr('data-alambic-owner-type')
      upload_policy_url = form.attr('data-upload-policy-url')
      authenticity_token = form.at('input[name=authenticity_token]').attr('value')
      avatar_filename = "#{login}.jpg"
      avatar = open(avatar_url)

      query = {
        name: avatar_filename,
        size: avatar.size,
        content_type: 'image/jpeg',
        authenticity_token: authenticity_token,
        owner_type: owner_type,
        owner_id: owner_id
      }

      page = agent.post(upload_policy_url, query)
      response = JSON.parse page.body

      File.open avatar.path do |avatar_file|
        query = response['asset'].merge({
          authenticity_token: authenticity_token,
          owner_type: owner_type,
          owner_id: owner_id,
          size: avatar.size,
          content_type: 'image/jpeg',
          file: avatar_file
        })

        # agent.agent.allowed_error_codes = [500]
        page = agent.post(response['upload_url'], query, response['header'])
        response = JSON.parse page.body
      end

      agent.get("https://github.com/settings/avatars/#{response['id']}") do |page|
        page = page.form_with(action: "/settings/avatars/#{response['id']}").submit
      end
    end
  end
end
