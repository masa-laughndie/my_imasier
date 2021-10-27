require 'rails_helper'

RSpec.describe Contracting, type: :model do
  describe ".do!" do
    subject { Contracting.do!(user: user, plan: plan, payment_method: payment_method) }

    let(:user) { FactoryBot.create(:user) }
    let(:plan) { FactoryBot.create(:plan)}
    let(:payment_method) { FactoryBot.create(:payment_method) }

    it "increase some models count and their contents is appropriate" do
      subject
      expect(License.count).to eq(1)
      expect(Contracting.count).to eq(1)
      expect(Contracting.last.license).to eq(License.last)
      expect(Contracting.last.price).to eq(plan.price)
      expect(LicenseRenewalReservation.count).to eq(1)
      expect(LicenseRenewalReservation.last.renewal_plan).to eq(plan)
      expect(LicenseRenewalPath.count).to eq(1)
      expect(LicenseRenewalPath.last.to_license_id).to eq(License.last.id)
      expect(LicenseRenewalPath.last.from_license_id).to eq(License.last.id)
    end
  end
end
