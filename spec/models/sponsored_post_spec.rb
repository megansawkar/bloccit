require 'rails_helper'

RSpec.describe SponsoredPost, type: :model do
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }
  let(:price) { RandomData.random_word }
  let(:topic) { Topic.create!(title: title, body: body) }
end

  it { is_expected.to have_many(:posts) }

  describe "attributes" do
    it "has title, body and price attributes" do
      expect(topic).to have_attributes(title: title, body: body, price: price)
    end
  end
