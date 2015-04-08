# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc 'Invites people to the HGRPG Slack channel'
task :slack_adder do
  typeform_id = 'dXj3qT'
  typeform_api_key = '0cec124a45aea361f6ba5689db9daf4e41a7b03c'
  typeform_email_field = 'email_5992124'
  old_email_filepath = "#{Dir.pwd}/config/previously_invited_emails.json"
  slack_host_name = 'hgrpg'
  slack_auto_join_channels = 'C04AG2ZBJ'
  slack_auth_token = 'xoxp-4356101380-4356101382-4381919055-ed0671'
  old_emails = []

  File.open(old_email_filepath, 'r') do |file|
    old_emails = JSON.parse(File.read(file))
  end

  old_emails = old_emails['emails'] # get old emails as array
  offset = old_emails.length
  typeform_api_url = URI.parse "https://api.typeform.com/v0/form/#{typeform_id}?key=#{typeform_api_key}&completed=true&offset=#{offset}"


  typeform_uri = URI(typeform_api_url)
  typeform_response = Net::HTTP.get(typeform_uri)
  typeform_data = JSON.parse(typeform_response)

  users_to_invite = []

  typeform_data['responses'].each do |response|
    user_email = response['answers'][typeform_email_field]
    unless users_to_invite.include?(user_email)
      users_to_invite.push user_email
    end
  end


  slack_invite_url = URI.parse "https://#{slack_host_name}.slack.com/api/users.admin.invite?t=#{Time.now.to_i}"
  slack_uri = URI(slack_invite_url)

  counter = 1

  users_to_invite.each do |user|
    puts "#{Time.now} - #{counter} - #{user} - inviting"

    body = {
        'email' => user,
        'channels' => slack_auto_join_channels,
        'token' => slack_auth_token,
        'set_active' => true,
        '_attempts' => 1
    }

    body = body.to_json

    req = Net::HTTP::Post.new(slack_uri, initheader = {'Content-Type' =>'application/json'})

    req.body = body
    res = Net::HTTP.start(slack_uri.hostname, slack_uri.port, :use_ssl => true) do |http|
      http.request(req)
    end

    res = JSON.parse(res.body)

    unless res['ok']
      puts "#{Time.now} - #{counter} - #{user} - invite successful"
      old_emails.push user
    else
      puts "#{Time.now} - #{counter} - #{user} - error: #{res['error']}"
    end

    counter += 1
  end


  File.open(old_email_filepath, "w") do |file|
    file.write({'emails' => old_emails}.to_json)
  end
end