require "devise_zxcvbn/email_tokeniser"
require "devise_zxcvbn/errors/devise_zxcvbn_error"
require "ostruct"

module Devise
  module Models
    module Zxcvbnable
      extend ActiveSupport::Concern

      delegate :min_password_score, to: "self.class"
      delegate :zxcvbn_tester, to: "self.class"

      included do
        validate :strong_password, unless: :skip_password_complexity?
      end

      def password_score
        @password_score = self.class.password_score(self)
      end

      def password_weak?
        password_score.score < min_password_score
      end

      protected

      def skip_password_complexity?
        !password_required?
      end

      private

      def strong_password
        if errors.messages.blank? && password_weak?
          errors.add :password, :weak_password, **i18n_variables
        end
      end

      def i18n_variables
        {
          feedback: zxcvbn_feedback,
          crack_time_display: time_to_crack,
          score: password_score.score,
          min_password_score: min_password_score
        }
      end

      def zxcvbn_feedback
        feedback = password_score.feedback.values.flatten.reject(&:empty?)
        return "Add another word or two. Uncommon words are better." if feedback.empty?

        feedback.join(". ").gsub(/\.\s*\./, ".")
      end

      def time_to_crack
        password_score.crack_times_display["offline_fast_hashing_1e10_per_second"]
      end

      class_methods do
        Devise::Models.config(self, :min_password_score)
        Devise::Models.config(self, :zxcvbn_tester)

        def password_score(user, arg_email = nil)
          return raise DeviseZxcvbnError, "the object must respond to password" unless user.respond_to?(:password)

          password = user.password.to_s

          zxcvbn_weak_words = []

          if arg_email
            zxcvbn_weak_words += [arg_email, *DeviseZxcvbn::EmailTokeniser.split(arg_email)]
          end

          # User method results are saved locally to prevent repeat calls that might be expensive
          if user.respond_to?(:email)
            local_email = user.email
            zxcvbn_weak_words += [local_email, *DeviseZxcvbn::EmailTokeniser.split(local_email)]
          end

          if user.respond_to?(:weak_words)
            return raise DeviseZxcvbnError, "weak_words must return an Array" unless user.weak_words.is_a?(Array)

            local_weak_words = user.weak_words
            zxcvbn_weak_words += local_weak_words
          end

          zxcvbn_tester.test(password, zxcvbn_weak_words)
        end
      end
    end
  end
end
