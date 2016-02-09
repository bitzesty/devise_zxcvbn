require "devise_zxcvbn"

describe 'Devise zxcvbn' do

  it "Returns the default value for min_password_score of 4" do
    expect(Devise.min_password_score).to eq(4)
  end

  it "Raises an error if min_password_score value is out of range" do
    expect { Devise.min_password_score = 8 }.to raise_error("The min_password_score must be an integer and between 0..4")
  end

  it "Sets the min_password_score value" do
    Devise.min_password_score = 2
    expect(Devise.min_password_score).to eq(2)
    Devise.min_password_score = 4 # Restore default
  end

  it "returns a memoized instance of Zxcvbn::Tester" do
    expect(::Zxcvbn::Tester).to receive(:new).once.and_call_original
    2.times { Devise.zxcvbn_tester }
  end
end
