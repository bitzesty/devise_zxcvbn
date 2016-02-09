# devise_zxcvbn

[![Gem Version](https://badge.fury.io/rb/devise_zxcvbn.png)](http://badge.fury.io/rb/devise_zxcvbn)
[![Circle CI](https://circleci.com/gh/bitzesty/devise_zxcvbn.svg?style=svg)](https://circleci.com/gh/bitzesty/devise_zxcvbn)

Plugin for [devise](https://github.com/plataformatec/devise) to reject weak passwords, using [zxcvbn-js](https://github.com/bitzesty/zxcvbn-js) which is a ruby port of [zxcvbn: realistic password strength estimation](https://tech.dropbox.com/2012/04/zxcvbn-realistic-password-strength-estimation/).
The user's password will be rejected if the score is below 4 by default. It also uses the email as user input to zxcvbn, to downscore passwords containing the email.

The scores 0, 1, 2, 3 or 4 are given when the estimated crack time (seconds) is less than `10**2`, `10**4`, `10**6`, `10**8`, Infinity.

## Installation

Add this line to your application's Gemfile:

    gem 'devise_zxcvbn'


## Configuration

    class User < ActiveRecord::Base
      devise :zxcvbnable

      # Optionally add more weak words to check against:
      def weak_words
        ['mysitename', self.name, self.username]
      end
    end

### Default parameters

_A score of less than 3 is not recommended._

    # config/initializers/devise.rb
    Devise.setup do |config|
      config.min_password_score = 4
    end

### Error Message

The defaul error message, displays an error:

    "not strong enough. It scored %{score}. It must score at least %{min_password_score}."

You can customize this error message modifiying the `devise` yaml file.

The `feedback`, `crack_time_display`, `score` and `min_password_score` variables are passed through if you need them.

    # config/locales/devise.en.yml
    en:
      errors:
        messages:
          weak_password: "not strong enough. Consider adding a number, symbols or more letters to make it stronger."


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
