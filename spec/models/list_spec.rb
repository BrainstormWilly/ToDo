require 'rails_helper'

RSpec.describe List, type: :model do

  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }

  it { is_expected.to have_many(:items) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(1) }
  it { is_expected.to validate_presence_of(:user) }

  describe "attributes" do
    it "should have title and user attributes" do
      expect(list).to have_attributes(title: list.title, user: user)
    end
  end

  describe "invalid list" do
    let(:list_with_invalid_title) { build(:list, title:"") }
    let(:list_with_invalid_user) { build(:list) }

    it "should be an invalid list due to blank title" do
      expect(list_with_invalid_title).to_not be_valid
    end

    it "should be an invalid list due to blank user" do
      expect(list_with_invalid_user).to_not be_valid
    end
  end

end
