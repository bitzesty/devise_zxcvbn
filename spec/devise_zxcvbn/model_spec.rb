require "devise"
require "devise_zxcvbn"
require "active_model"
require "devise_zxcvbn/model"

describe Devise::Models::Zxcvbnable do
  ValidDummyClass = Struct.new(:password) do
    include ActiveModel::Validations
    include Devise::Models::Zxcvbnable

    def password_required?
      true
    end
  end

  describe "#password_score" do
    context "when password is strong" do
      let(:user) { ValidDummyClass.new("Jm1C4C3aaDzC1aRW") }

      it "returns the score equal 4" do
        password_score = user.password_score

        expect(password_score.score).to eq(4)
        expect(password_score.crack_times_display['offline_fast_hashing_1e10_per_second']).to eq("12 days")
      end
    end

    context "when password is weak" do
      let(:user) { ValidDummyClass.new("12345678") }

      it "returns the weak score" do
        password_score = user.password_score

        expect(password_score.score).to eq(0)
        expect(password_score.crack_times_display['offline_fast_hashing_1e10_per_second']).to eq("less than a second")
      end
    end
  end

  describe "#password_weak?" do
    let(:user) { ValidDummyClass.new("Jm1C4C3aaDzC1aRW") }

    it "returns false for the call of the method" do
      expect(user.password_weak?).to be_falsey
    end
  end

  describe "validations" do
    context "when password score is strong" do
      let(:user) { ValidDummyClass.new("Jm1C4C3aaDzC1aRW") }

      it "doesn't return validation message and returns true for validate" do
        expect(user).to be_valid
        expect(user.errors[:password]).to be_empty
      end
    end

    context "when password score is week" do
      let(:user) { ValidDummyClass.new("12345678") }

      it "returns false for validate" do
        expect(user).to_not be_valid
      end

      it "returns validation message" do
        user.validate

        expect(user.errors[:password])
          .to eq(["not strong enough. It scored 0. It must score at least 4."])
      end
    end
  end

  describe "exceptions raises" do
    context "when password method is not given for instance" do
      class InvalidPasswordDummyClass < ValidDummyClass
        undef_method :password
      end

      let(:user) { InvalidPasswordDummyClass.new }

      it "raises exception regarding absence password method" do
        expect { user.password_score }.to raise_error(DeviseZxcvbnError, "the object must respond to password")
      end
    end

    context "when weak_words method returns not Array" do
      class InvalidWeakWordsDummyClass < ValidDummyClass
        def weak_words
          String.new()
        end
      end

      let(:user) { InvalidWeakWordsDummyClass.new }

      it "raises exception regarding type of weak_words method" do
        expect { user.password_score }.to raise_error(DeviseZxcvbnError, "weak_words must return an Array")
      end
    end
  end
end
