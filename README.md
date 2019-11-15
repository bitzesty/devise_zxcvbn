# devise_zxcvbn

[![Gem Version](https://badge.fury.io/rb/devise_zxcvbn.svg)](http://badge.fury.io/rb/devise_zxcvbn)
[![Circle CI](https://circleci.com/gh/bitzesty/devise_zxcvbn.svg?style=svg)](https://circleci.com/gh/bitzesty/devise_zxcvbn)
[![Code Climate](https://codeclimate.com/github/bitzesty/devise_zxcvbn/badges/gpa.svg)](https://codeclimate.com/github/bitzesty/devise_zxcvbn)

Plugin for [devise](https://github.com/plataformatec/devise) to reject weak passwords, using [zxcvbn-js](https://github.com/bitzesty/zxcvbn-js) which is a ruby port of [zxcvbn: realistic password strength estimation](https://tech.dropbox.com/2012/04/zxcvbn-realistic-password-strength-estimation/).

The user's password will be rejected if the score is below 4 by default. It also uses the email as user input to zxcvbn, to reject passwords containing parts of the email (if using zxcvbn.js on the frontend you should also do this to get the same score).

The scores 0, 1, 2, 3 or 4 are given when the estimated crack time (seconds) is less than `10**2`, `10**4`, `10**6`, `10**8`, Infinity.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_zxcvbn'
```

## Configuration

```ruby
class User < ActiveRecord::Base
  devise :zxcvbnable

  # Optionally add more weak words to check against:
  def weak_words
    ['mysitename', self.name, self.username]
  end
end
```

## Available methods for devise resources

```ruby
class User < ApplicationRecord
  devise :zxcvbnable
end

user = User.new.tap do |user|
  user.email = "example@example.com"
  user.password = "123456789"
end

user.password_score => #<OpenStruct password="123456789", guesses=6, guesses_log10=0.7781512503836435, sequence=[{"pattern"=>"dictionary", "i"=>0, "j"=>8, "token"=>"123456789", "matched_word"=>"123456789", "rank"=>5, "dictionary_name"=>"passwords", "reversed"=>false, "l33t"=>false, "base_guesses"=>5, "uppercase_variations"=>1, "l33t_variations"=>1, "guesses"=>5, "guesses_log10"=>0.6989700043360187}], calc_time=15, crack_times_seconds={"online_throttling_100_per_hour"=>216, "online_no_throttling_10_per_second"=>0.6, "offline_slow_hashing_1e4_per_second"=>0.0006, "offline_fast_hashing_1e10_per_second"=>6.0e-10}, crack_times_display={"online_throttling_100_per_hour"=>"4 minutes", "online_no_throttling_10_per_second"=>"less than a second", "offline_slow_hashing_1e4_per_second"=>"less than a second", "offline_fast_hashing_1e10_per_second"=>"less than a second"}, score=0, feedback={"warning"=>"This is a top-10 common password", "suggestions"=>["Add another word or two. Uncommon words are better."]}>
# returns a simple OpenStruct object so than you could send another messages to get more info

user.password_weak? => true/false # returns a boolean result of checking of weakness of your set password
```

### Default parameters

_A score of less than 3 is not recommended._

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.min_password_score = 4
end
```

### Error Message

The default error message:

```yml
"not strong enough. It scored %{score}. It must score at least %{min_password_score}."
```

You can customize this error message modifying the `devise` YAML file.

The `crack_time_display`, `feedback`, `score` and `min_password_score` variables are passed through if you need them.

```yml
# config/locales/devise.en.yml
en:
  errors:
    messages:
      weak_password: "not strong enough. Consider adding a number, symbols or more letters to make it stronger."
```

### Skipping password complexity validation

To turn off password complexity validation for certain conditions, you could implement a concern (or similar) that overloads `skip_password_complexity?`:

```ruby
def skip_password_complexity?
  true
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add test coverage for the feature, We use rspec for this purpose
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
