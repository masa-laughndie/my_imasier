require 'rails_helper'

RSpec.describe Contracting, type: :model do
  describe ".do!" do
    subject { Contracting.do!(user: user, plan: plan, payment_method: payment_method) }

    let(:user) { FactoryBot.create(:user) }
    let(:plan) { FactoryBot.create(:plan)}
    let(:payment_method) { FactoryBot.create(:payment_method) }

    it "increase some models count" do
      subject
      expect(License.count).to eq(1)
      expect(Contracting.count).to eq(1)
    end
  end
end
