require "devise_zxcvbn/version"
require "devise"
require "zxcvbn"

module Devise

  # The minimun score for a password.
  mattr_reader :min_password_score
  @@min_password_score = 4

  def self.min_password_score=(score)
    raise "The min_password_score must be an integer and between 0..4" unless (0..4).include?(score)
    @@min_password_score = score
  end
end

# Load default I18n
#
I18n.load_path.unshift File.join(File.dirname(__FILE__), *%w[devise_zxcvbn locales en.yml])

Devise.add_module :zxcvbnable, model: "devise_zxcvbn/model"
