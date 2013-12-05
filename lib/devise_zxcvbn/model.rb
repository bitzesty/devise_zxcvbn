module Devise
  module Models
    module Zxcvbnable
      extend ActiveSupport::Concern

      delegate :min_password_score, to: "self.class"

      included do
        validate :not_weak_password, if: :password_required?
      end

      private

      def not_weak_password
        password_score = ::Zxcvbn.test(password, [self.email]).score
        if password_score < min_password_score
          self.errors.add :password, :weak_password, score: password_score, min_password_score: min_password_score
          return false
        end
      end

      module ClassMethods
        Devise::Models.config(self, :min_password_score)
      end
    end
  end
end