require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Warehouse
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    ActiveValidators.activate(:url)

    config.filter_parameters << :password
    config.autoload_paths += [
        config.root.join('app')
    ]

    config.staff_permissions = {
        :account_edit => %w(ADMIN MODERATOR LIBRARIAN),
        :account_delete => %w(ADMIN),
        :account_ban => %w(ADMIN MODERATOR),
        :account_promote => %w(ADMIN),
        :admin_panel => %w(ADMIN LIBRARIAN),
        :character_edit => %w(ADMIN LIBRARIAN),
        :character_approve => %w(ADMIN LIBRARIAN MODERATOR),
        :fc_approve => %w(ADMIN LIBRARIAN)
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
        13 => 'Glaive',
        14 => 'Spiked Blunt',
        15 => 'Javelin'
    }
  end
end
