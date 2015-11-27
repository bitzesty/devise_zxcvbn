require "devise_zxcvbn/version"
require "devise"
require "zxcvbn"

module Devise

  @@min_password_score = 4

  def self.min_password_score
    @@min_password_score
  end

  def self.min_password_score=(score)
    if (0..4).include?(score)
      if score < 3
        ::Rails.logger.warn "[devise_zxcvbn] A score of less than 3 is not recommended."
      end
      @@min_password_score = score
    else
      raise "The min_password_score must be an integer and between 0..4"
    end
  end

  def self.zxcvbn_tester
    @@zxcvbn_tester ||= ::Zxcvbn::Tester.new
  end
end

Devise.add_module :zxcvbnable, :model => "devise_zxcvbn/model"
