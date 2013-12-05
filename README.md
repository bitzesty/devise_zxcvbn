# devise_zxcvbn

Plugin for devise to reject weak passwords, using [zxcvbn-ruby](https://github.com/envato/zxcvbn-ruby) which is a ruby port of [zxcvbn: realistic password strength estimation](https://tech.dropbox.com/2012/04/zxcvbn-realistic-password-strength-estimation/). 
The user's password will be rejected if the score is below 3 by default. It also uses the email as user input to zxcvbn, to downscore passwords containing the email.

## Installation

Add this line to your application's Gemfile:

    gem 'devise_zxcvbn'


## Devise Configuration

    class User < ActiveRecord::Base
      devise :database_authenticatable, :zxcvbnable
    end

Default parameters

    Devise.setup do |config|
      config.min_password_score = 3  # 0, 1, 2, 3 or 4
    end

### Error Message

    # config/locale/devise.en.yml
    en:
      errors:
        messages:
          weak_password: "not strong enough. It scored %{score}. It must score at least %{min_password_score}."


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
