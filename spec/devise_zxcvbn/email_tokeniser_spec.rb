# encoding: UTF-8
require 'devise_zxcvbn/email_tokeniser'

describe DeviseZxcvbn::EmailTokeniser do
  it "should split an email into tokens" do
    expect(split("joe_bloggs@digital.gov-office.gov.uk")).to eq(%w(joe bloggs digital gov office gov uk))
  end

  it "should not split non-ascii characters" do
    expect(split("björn@email.com")).to eq(%w(björn email com))
  end

  def split(email)
    DeviseZxcvbn::EmailTokeniser.split(email)
  end
end
