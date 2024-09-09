require 'rails_helper'

describe Rating do
  describe "crud" do
    context "given proper inputs" do
      it "returns a arating" do
        rating = FactoryBot.build(:rating)
        expect(rating).to be_valid
      end
    end

    context "given improper inputs" do
      it "returns a an error" do
        rating = FactoryBot.build(:rating, user: nil)
        expect(rating).not_to be_valid
        rating = FactoryBot.build(:rating, rater: nil)
        expect(rating).not_to be_valid
        rating = FactoryBot.build(:rating, rating: nil)
        expect(rating).not_to be_valid
        rating = FactoryBot.build(:rating, rating: 100)
        expect(rating).not_to be_valid
      end
    end
  end
end
