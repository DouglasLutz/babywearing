# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CarrierPolicy do
  subject(:instance) { described_class }

  let(:admin) { users(:admin) }
  let(:volunteer) { users(:volunteer) }
  let(:member) { users(:member) }

  permissions :create? do
    it { is_expected.not_to permit(member) }

    it { is_expected.to permit(admin) }

    it { is_expected.to permit(volunteer) }
  end

  permissions :update? do
    it { is_expected.not_to permit(member) }

    it { is_expected.to permit(admin) }

    it { is_expected.to permit(volunteer) }
  end

  permissions :destroy? do
    it { is_expected.not_to permit(member) }

    it { is_expected.to permit(admin) }

    it { is_expected.to permit(volunteer) }
  end

  permissions :checkout? do
    it { is_expected.not_to permit(member, carriers(:unavailable)) }

    it { is_expected.to permit(admin, carriers(:carrier)) }
  end
end
