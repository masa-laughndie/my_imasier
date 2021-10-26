require 'rails_helper'

RSpec.describe DownloadRightsGranting, type: :model do
  describe "#max_carryover_number" do
    subject { granting.max_carryover_number }
    context "when interval is 1 month and valid duration is 1 month" do
      let(:granting) {
        FactoryBot.build(:download_rights_granting, right_count: 10,
                                                    interval_number: 1,
                                                    interval_unit: "month",
                                                    valid_duration_number: 1,
                                                    valid_duration_unit: "month",)
      }

      it { is_expected.to eq 0 }
    end

    context "when interval is 1 month and valid duration is 1 year" do
      let(:granting) {
        FactoryBot.build(:download_rights_granting, right_count: 10,
                                                    interval_number: 1,
                                                    interval_unit: "month",
                                                    valid_duration_number: 1,
                                                    valid_duration_unit: "year",)
      }

      it { is_expected.to eq 11 }
    end
  end

  describe "#max_carryover_right_count" do
    subject { granting.max_carryover_right_count }
    context "when interval is 1 month and valid duration is 1 month" do
      let(:granting) {
        FactoryBot.build(:download_rights_granting, right_count: 10,
                                                    interval_number: 1,
                                                    interval_unit: "month",
                                                    valid_duration_number: 1,
                                                    valid_duration_unit: "month",)
      }

      it { is_expected.to eq 0 }
    end

    context "when interval is 1 month and valid duration is 1 year" do
      let(:granting) {
        FactoryBot.build(:download_rights_granting, right_count: 5,
                                                    interval_number: 1,
                                                    interval_unit: "month",
                                                    valid_duration_number: 1,
                                                    valid_duration_unit: "year",)
      }

      it { is_expected.to eq 55 }
    end
  end
end
