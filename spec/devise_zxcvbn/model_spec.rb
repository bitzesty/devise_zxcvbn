require 'active_model'
require 'action_view'
require 'devise'
require 'devise_zxcvbn'
require 'devise_zxcvbn/model'

describe Devise::Models::Zxcvbnable do
  ValidDummyClass = Struct.new(:password, :skip_password_complexity, keyword_init: true) do
    include ActiveModel::Validations
    include Devise::Models::Zxcvbnable

    def skip_password_complexity?
      skip_password_complexity
    end
  end

  let(:skip_password_complexity) { false }

  describe '#password_score' do
    context 'when password is strong' do
      let(:user) { ValidDummyClass.new(password: 'Jm1C4C3aaDzC1aRW', skip_password_complexity: skip_password_complexity) }

      it 'returns the score equal 4' do
        password_score = user.password_score

        expect(password_score.score).to eq(4)
        expect(password_score.crack_times_display['offline_fast_hashing_1e10_per_second']).to eq('12 days')
        expect(user.send(:time_to_crack)).to eq('12 days')
      end
    end

    context 'when password is weak' do
      let(:user) { ValidDummyClass.new(password: '12345678', skip_password_complexity: skip_password_complexity) }

      it 'returns the weak score' do
        password_score = user.password_score

        expect(password_score.score).to eq(0)
        expect(password_score.crack_times_display['offline_fast_hashing_1e10_per_second']).to eq('less than a second')
        expect(user.send(:time_to_crack)).to eq('less than 5 seconds')
      end
    end
  end

  describe '#password_weak?' do
    let(:user) { ValidDummyClass.new(password: 'Jm1C4C3aaDzC1aRW', skip_password_complexity: skip_password_complexity) }

    it 'returns false for the call of the method' do
      expect(user.password_weak?).to be_falsey
    end
  end

  describe 'validations' do
    subject { resource.validate; resource }

    let(:resource) { ValidDummyClass.new(password: password, skip_password_complexity: skip_password_complexity) }

    context 'when password complexity check is required' do
      context 'when password is strong' do
        let(:password) { 'Jm1C4C3aaDzC1aRW' }

        it 'expects the model to be valid' do
          expect(subject).to be_valid
        end

        it 'returns empty validation messages' do
          expect(subject.errors[:password]).to be_empty
        end
      end

      context 'when password is weak' do
        let(:password) { '12345678' }

        it 'expects the model to be invalid' do
          expect(subject).to be_invalid
        end

        it 'returns validation message' do
          expect(subject.errors[:password])
            .to eq(['not strong enough. It scored 0. It must score at least 4.'])
        end
      end
    end

    context 'when password complexity check is not required' do
      let(:skip_password_complexity) { true }

      context 'when password score is strong' do
        let(:password) { 'Jm1C4C3aaDzC1aRW' }

        it 'expects the model to be valid' do
          expect(subject).to be_valid
        end
      end

      context 'when password score is weak' do
        let(:password) { '12345678' }

        it 'expects the model to be valid' do
          expect(subject).to be_valid
        end
      end
    end
  end

  describe 'exceptions raises' do
    context 'when password method is not given for instance' do
      class InvalidPasswordDummyClass < ValidDummyClass
        undef_method :password
      end

      let(:user) { InvalidPasswordDummyClass.new }

      it 'raises exception regarding absence password method' do
        expect { user.password_score }.to raise_error(DeviseZxcvbnError, 'the object must respond to password')
      end
    end

    context 'when weak_words method returns not Array' do
      class InvalidWeakWordsDummyClass < ValidDummyClass
        def weak_words
          String.new()
        end
      end

      let(:user) { InvalidWeakWordsDummyClass.new }

      it 'raises exception regarding type of weak_words method' do
        expect { user.password_score }.to raise_error(DeviseZxcvbnError, 'weak_words must return an Array')
      end
    end
  end
end
