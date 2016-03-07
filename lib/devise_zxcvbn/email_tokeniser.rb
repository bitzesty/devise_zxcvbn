module DeviseZxcvbn
  class EmailTokeniser
    def self.split(email_address)
      email_address.to_s.split(/[[:^word:]_]/)
    end
  end
end
