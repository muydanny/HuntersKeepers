# frozen_string_literal: true

require 'rails_helper'

describe 'hunters#show' do
  let(:user) { create :user }
  let!(:hunter) { create :hunter, user: user, experience: 5, harm: 4 }

  before :each do
    sign_in user
  end

  it 'shows a hunters values' do
    visit "/hunters/#{hunter.id}".dup
    expect(page).to have_content hunter.name
    expect(page).to have_link hunter.playbook.name, href: playbook_path(hunter.playbook)
    expect(page).to have_content hunter.playbook.description
    expect(page).to have_content "Harm: #{hunter.harm}"
    expect(page).to have_content "UNSTABLE"
    expect(page).to have_content "Luck: #{hunter.luck}"
    expect(page).to have_content "Experience: #{hunter.experience}"
    expect(page).to have_link 'Take an Improvement', href: new_hunter_hunters_improvement_path(hunter_id: hunter.id)
  end

  context 'with basic moves' do
    let!(:basic_move) { create(:moves_basic, name: 'The Nameless Move') }
    
    before { hunter.moves << basic_move }

    it 'lets the user roll basic moves', js: true do
      visit "/hunters/#{hunter.id}".dup
      within('#moves') do
      find('.card-header-title').click
        expect(page).to have_content("(cool #{hunter.cool})")
      end
      expect(page).to have_content(basic_move.name)
    end
  end
end
