# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'create user links' do
  let(:admin) { users(:admin) }
  let(:volunteer) { users(:volunteer) }
  let(:member) { users(:member) }

  scenario 'when user is an admin or a volunteer' do
    [admin, volunteer].each do |user|
      sign_in user
      visit(root_path)

      expect(page).to have_link('CREATE USER')
    end
  end

  scenario 'when user is a member' do
    sign_in member
    visit(root_path)

    expect(page).not_to have_link('CREATE USER')
  end

  scenario 'when user is not logged in' do
    visit(root_path)

    expect(page).not_to have_link('CREATE USER')
  end
end
