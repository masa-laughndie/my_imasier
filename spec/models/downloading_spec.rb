require 'rails_helper'

RSpec.describe Downloading, type: :model do
  describe ".do!" do
    let(:downloading) { -> { travel(download_in) { Downloading.do!(user: user, license: downloadable_license, item_id: item_id) } } }

    let!(:user) { FactoryBot.create(:user) }
    let!(:payment_method) { FactoryBot.create(:payment_method) }
    let!(:plan) do
      FactoryBot.create(
        :plan,
        :contract_1_year,
        download_rights_count: 2,
        download_rights_interval: 1.month,
        download_rights_valid_duration: 1.year,
      )
    end

    before do
      Contracting.do!(user: user, plan: plan, payment_method: payment_method)
      user.assaign!(user, user.contracted_licenses.first)
    end

    let!(:original_license) { user.exercisable_licenses.first }
    let(:downloadable_license) { user.reload.exercisable_licenses.within_exercisable_duration(download_in.from_now).last }
    let(:item_id) { rand(100_000) }

    context "without carryover" do
      let(:download_in) { 10.seconds }

      context "can download to the limit" do
        subject { 2.times { downloading.call } }

        it { expect { subject }.not_to raise_error }
        it { expect { subject }.to change { Downloading.count }.by(2) }
      end

      context "cannot download over the limit" do
        subject { 3.times { downloading.call } }

        it { expect { subject }.to raise_error(NoMethodError) }
      end
    end

    context "with carryover" do
      context "within a license" do
        let(:download_in) { 11.months + 10.seconds }

        context "can download to the limit" do
          subject { 24.times { downloading.call } }

          before do
            downloadable_license.reload
          end

          it { expect { subject }.not_to raise_error }
          it { expect { subject }.to change { Downloading.count }.by(24) }
        end

        context "cannot download over the limit" do
          subject { 25.times { downloading.call } }

          it { expect { subject }.to raise_error(NoMethodError) }
        end
      end

      context "across licenses" do
        before do
          original_license.change_renewal_plan_to(renewal_plan)
          original_license.renew!
          downloadable_license.reload
        end

        let!(:download_in) { 1.year + 10.seconds }

        context "of the same plan" do
          let(:renewal_plan) { plan }

          context "can download to the limit" do
            subject { 24.times { downloading.call } }

            it { expect { subject }.not_to raise_error }
            it { expect { subject }.to change { Downloading.count }.by(24) }
          end

          context "cannot download over the limit" do
            subject { 25.times { downloading.call } }

            it { expect { subject }.to raise_error(NoMethodError) }
          end
        end

        context "of different plan" do
          let(:renewal_plan) {
            FactoryBot.create(
              :plan,
              :contract_1_month,
              download_rights_count: 3,
              download_rights_interval: 1.month,
              download_rights_valid_duration: 1.year,
            )
          }

          context "can download to the limit" do
            subject { 25.times { downloading.call } }

            it { expect { subject }.not_to raise_error }
            it { expect { subject }.to change { Downloading.count }.by(25) }
          end

          context "cannot download over the limit" do
            subject { 26.times { downloading.call } }

            it { expect { subject }.to raise_error(NoMethodError) }
          end
        end
      end
    end
  end
end
