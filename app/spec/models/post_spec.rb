require 'rails_helper'

describe Post do
  describe "crud" do
    context "given proper inputs" do
      it "returns a post" do
        post = FactoryBot.build(:post)
        expect(post).to be_valid
      end
    end

    context "given improper inputs" do
      it "returns a an error" do
        post = FactoryBot.build(:post, user: nil)
        expect(post).not_to be_valid
        post = FactoryBot.build(:post, title: nil)
        expect(post).not_to be_valid
        post = FactoryBot.build(:post, body: nil)
        expect(post).not_to be_valid
      end
    end
  end
end
