require 'rails_helper'

RSpec.describe List, type: :model do

  let(:user) { create(:user) }
  let(:list) { create(:list, user: user) }

  it { is_expected.to have_many(:items) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(1) }
  it { is_expected.to validate_presence_of(:user) }

  describe "attributes" do
    it "should have title, permissions, and user attributes" do
      expect(list).to have_attributes(title: list.title, user: user, permissions: list.permissions)
    end
    it "should default to public permissions" do
      expect(list.permissions).to eq "to_public"
    end
    it "should respond to permissions" do
      expect(list).to respond_to (:permissions)
    end
    it "should respond to to_public?" do
      expect(list).to respond_to (:to_public?)
    end
    it "to_public? default should be truthy" do
      expect(list.to_public?).to be_truthy
    end
    it "should respond to to_private?" do
      expect(list).to respond_to (:to_private?)
    end
    it "to_private? default should be falsey" do
      expect(list.to_private?).to be_falsey
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
