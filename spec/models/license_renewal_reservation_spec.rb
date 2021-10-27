require 'rails_helper'

RSpec.describe LicenseRenewalReservation, type: :model do
  describe "#execute!" do
    subject { license_renewal_reservation.execute! }

    let(:user) { FactoryBot.create(:user) }
    let(:payment_method) { FactoryBot.create(:payment_method) }

    before do
      Contracting.do!(user: user, plan: plan, payment_method: payment_method)
      user.assaign!(user, user.contracted_licenses.last)
    end

    let(:license_renewal_reservation) { user.contracted_licenses.first.renewal_reservation }

    context "when single seat license" do
      let(:plan) { FactoryBot.create(:plan, :single, :contract_1_year, :with_download_rights_granting) }

      it "increase some models count and their contents is appropriate" do
        subject
        expect(License.count).to eq(2)
        expect(Contracting.count).to eq(2)
        expect(LicenseRenewalReservation.count).to eq(2)
        expect(LicenseRenewalPath.count).to eq(3)
        expect(DownloadRight.count).to eq(24)
        expect(LicenseSeat.count).to eq(2)
      end
    end

    context "when multi seat license" do
      let(:plan) { FactoryBot.create(:plan, :multi, :contract_1_year, :with_download_rights_granting) }

      it "increase some models count and their contents is appropriate" do
        subject
        expect(License.count).to eq(2)
        expect(Contracting.count).to eq(2)
        expect(LicenseRenewalReservation.count).to eq(2)
        expect(LicenseRenewalPath.count).to eq(3)
        expect(DownloadRight.count).to eq(24)
        expect(LicenseSeat.count).to eq(2)
      end
    end
  end
end
