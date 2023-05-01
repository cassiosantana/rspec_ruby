require 'rails_helper'

RSpec.describe "Weapons", type: :request do
  describe "GET /index" do
    context 'present attributes' do
      it "the weapon name is present" do
        weapons = create_list(:weapon, 3)
        get weapons_path
        weapons.each do |weapon|
          expect(response.body).to include(weapon.name)
        end
      end

      it "the weapon current power is present" do
        weapons = create_list(:weapon, 3)
        get weapons_path
        weapons.each do |weapon|
          expect(response.body).to include("#{ weapon.current_power }")
        end
      end

      it "the weapon title is present" do
        weapons = create_list(:weapon, 3)
        get weapons_path
        weapons.each do |weapon|
          expect(response.body).to include(weapon.title)
        end
      end
    end

    context 'show weapon link' do
      it 'weapon link is present' do
        weapons = create_list(:weapon, 10)
        get weapons_path
        weapons.each do |weapon|
          expect(response.body).to include("/weapons/#{ weapon.id }")
        end
      end
    end
  end

  describe 'weapon creation' do
    context 'when parameters are correct' do
    it 'weapon created' do
        weapon_attributes = FactoryBot.attributes_for(:weapon)
        post weapons_path, params: { weapon: weapon_attributes }
        # checks if the last weapon sent in the post has the same attributes that were created before the post
        expect(Weapon.last).to have_attributes(weapon_attributes)
      end
    end
  end
end
