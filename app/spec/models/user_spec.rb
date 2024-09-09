require 'rails_helper'

describe User do
  describe "crud" do
    context "given proper inputs" do
      it "returns a user" do
        user = FactoryBot.build(:user)
        expect(user).to be_valid
      end
    end

    context "given improper inputs" do
      it "returns a an error" do
        user = FactoryBot.build(:user, email: nil)
        expect(user).not_to be_valid
        user = FactoryBot.build(:user, password: nil)
        expect(user).not_to be_valid
        user = FactoryBot.build(:user, name: nil)
        expect(user).not_to be_valid
      end
    end
  end
end
