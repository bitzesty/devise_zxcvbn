require "devise"
require "devise_zxcvbn"
require "active_model"
require "devise_zxcvbn/model"

describe Devise::Models::Zxcvbnable do
  describe "#password_score" do
    it "returns the score from zxcvbn_tester" do
      password_score = DummyClass.new("12345678").password_score
      expect(password_score.score).to eq(0)
      expect(password_score.crack_times_display['offline_fast_hashing_1e10_per_second']).to eq("less than a second")
    end
  end

  describe "Password validation" do
    it "Invalid if password score is less than the min_password_score" do
      user = DummyClass.new("12345678")
      expect(user).to_not be_valid
      expect(user.errors[:password]).to eq(["not strong enough. It scored 0. It must score at least 4."])
    end

    it "Valid if password score is greater than the min_password_score" do
      user = DummyClass.new("Jm1C4C3aaDzC")
      expect(user).to be_valid
      expect(user.errors[:password]).to be_empty
    end
  end

  class DummyClass
    include ActiveModel::Validations
    include Devise::Models::Zxcvbnable

    attr_accessor :password

    def initialize(password)
      @password = password
    end

    def password_required?
      true
    end
  end
end
