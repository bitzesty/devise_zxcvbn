require 'devise_zxcvbn/email_tokeniser'

module Devise
  module Models
    module Zxcvbnable
      extend ActiveSupport::Concern

      delegate :min_password_score, to: "self.class"
      delegate :zxcvbn_tester, to: "self.class"

      included do
        validate :not_weak_password, if: :password_required?
      end

      def password_score
        self.class.password_score(self)
      end

      private

      def not_weak_password
        if password_score < min_password_score
          self.errors.add :password, :weak_password, score: password_score, min_password_score: min_password_score
          return false
        end
      end

      module ClassMethods
        Devise::Models.config(self, :min_password_score)
        Devise::Models.config(self, :zxcvbn_tester)

        def password_score(user, arg_email=nil)
          password = user.respond_to?(:password) ? user.password : user

          zxcvbn_weak_words = []

          if arg_email
            zxcvbn_weak_words += [arg_email, *DeviseZxcvbn::EmailTokeniser.split(arg_email)]
          end

          # User method results are saved locally to prevent repeat calls that might be expensive
          if user.respond_to? :email
            local_email = self.email
            zxcvbn_weak_words += [local_email, *DeviseZxcvbn::EmailTokeniser.split(local_email)]
          end

          if user.respond_to? :weak_words
            local_weak_words = self.weak_words
            raise "weak_words must return an Array" unless (local_weak_words.is_a? Array)
            zxcvbn_weak_words += local_weak_words
          end

          zxcvbn_tester.test(password, zxcvbn_weak_words).score
        end
      end
    end
  end
end
