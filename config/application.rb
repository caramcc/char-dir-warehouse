require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class Application < Rails::Application
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
  # config.time_zone = 'Central Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  # config.i18n.default_locale = :de

  # Do not swallow errors in after_commit/after_rollback callbacks.
  config.active_record.raise_in_transactional_callbacks = true

  config.filter_parameters << :password

  config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**/}')]
  config.autoload_paths += Dir[Rails.root.join('lib', '{**}')]

  # # config.paths.add 'app/api', glob: '**/*.rb'
  # # config.autoload_paths += Dir["#{Rails.root}/app/models/*"]
  # config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
  # config.autoload_paths += [
  #     config.root.join('app')
  # ]

  config.staff_permissions = {
      :account_edit => %w(ADMIN MODERATOR LIBRARIAN),
      :account_delete => %w(ADMIN),
      :account_ban => %w(ADMIN MODERATOR),
      :account_promote => %w(ADMIN),
      :admin_panel => %w(ADMIN LIBRARIAN),
      :character_edit => %w(ADMIN LIBRARIAN),
      :character_approve => %w(ADMIN LIBRARIAN MODERATOR),
      :fc_approve => %w(ADMIN LIBRARIAN),
      :open_games => %W(ADMIN)
  }


  config.weapon_codes = {
      1 => 'Sword',
      2 => 'Knife',
      3 => 'Spear',
      4 => 'Bow',
      5 => 'Unarmed',
      6 => 'Whip',
      7 => 'Blunt',
      8 => 'Projectile',
      9 => 'Thrown Knife',
      10 => 'Thrown Axe',
      11 => 'Axe',
      12 => 'Flail',
      13 => 'Glaive'
  }
end
