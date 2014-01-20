module DeviseZxcvbn
  class EmailTokeniser
    def self.split(email_address)
      email_address.split(/[[:^word:]_]/)
    end
  end
end
