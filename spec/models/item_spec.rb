require 'rails_helper'

RSpec.describe Item, type: :model do

  let( :user ){ create(:user) }
  let( :list ){ create(:list, user: user) }
  let( :item ){ create(:item, list: list) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(1) }
  it { is_expected.to validate_presence_of(:list) }

  describe "attributes" do
    it "should have title, list attributes" do
      expect(item).to have_attributes(title: item.title, list: list)
    end
  end

  describe "invalid item" do
    let(:item_with_invalid_title) { build(:item, title:"") }
    let(:item_with_invalid_list) { build(:item) }

    it "should be an invalid item due to blank title" do
      expect(item_with_invalid_title).to_not be_valid
    end

    it "should be an invalid item due to blank list" do
      expect(item_with_invalid_list).to_not be_valid
    end
  end

end
