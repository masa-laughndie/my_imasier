class ContractingsController < ApplicationController
  # subscriotions#create action
  def create
    current_user = User.first
    plan = Plan.first
    payment_method = PaymentMethod.first

    contracting = Contracting.do!(user: current_user, plan: plan, payment_method: payment_method)
    current_user.assaign!(current_user, contracting.license)
  end
end
