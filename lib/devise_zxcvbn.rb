require "devise_zxcvbn/version"
require "devise"
require "zxcvbn"

module Devise

  @@min_password_score = 4

  def self.min_password_score
    @@min_password_score
  end
    
  def self.min_password_score=(score)
    if score.is_a?(Integer) && (score >= 0 && score <=4)
      if score >= 3
        @@min_password_score = score
      else
        ::Rails.logger.warn "[devise_zxcvbn] A score of less than 3 is not recommended." 
        @@min_password_score = score
      end
    else
      raise "The min_password_score must be an integer and between 0..4"
    end
  end
end

Devise.add_module :zxcvbnable, :model => "devise_zxcvbn/model"
