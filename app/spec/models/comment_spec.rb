require 'rails_helper'

describe Comment do
  describe "crud" do
    context "given proper inputs" do
      it "returns a comment" do
        comment = FactoryBot.build(:comment)
        expect(comment).to be_valid
      end
    end

    context "given improper inputs" do
      it "returns an error" do
        comment = FactoryBot.build(:comment, user: nil)
        expect(comment).not_to be_valid
        comment = FactoryBot.build(:comment, post: nil)
        expect(comment).not_to be_valid
        comment = FactoryBot.build(:comment, message: nil)
        expect(comment).not_to be_valid
      end
    end
  end
end
