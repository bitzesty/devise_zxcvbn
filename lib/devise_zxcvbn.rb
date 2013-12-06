require "devise_zxcvbn/version"
require "devise"
require "zxcvbn"

module Devise
  mattr_accessor :min_password_score
  @@min_password_score = 4
end

Devise.add_module :zxcvbnable, :model => "devise_zxcvbn/model"
