require 'rails_helper'

RSpec.describe Contracting, type: :model do
  describe ".do!" do
    subject { Contracting.do!(user: user, plan: plan, payment_method: payment_method) }

    let(:user) { FactoryBot.create(:user) }
    let(:payment_method) { FactoryBot.create(:payment_method) }

    context "when plan's contract duration is 1 month" do
      let(:plan) { FactoryBot.create(:plan, :contract_1_month, :with_download_rights_granting)}

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
        expect(DownloadRight.count).to eq(1)
        expect(License.find_by(user: user).download_rights.first.valid_from).to eq(License.find_by(user: user).exercisable_from)
      end
    end

    context "when plan's contract duration is 1 year" do
      let(:plan) { FactoryBot.create(:plan, :contract_1_year, :with_download_rights_granting)}

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
        expect(DownloadRight.count).to eq(12)
        expect(License.find_by(user: user).download_rights.first.valid_from).to eq(License.find_by(user: user).exercisable_from)
      end
    end
  end
end
