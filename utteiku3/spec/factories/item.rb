FactoryGirl.define do
  factory :item do
    description { "素敵な#{name}です。" }
    price       1_000
    image_url   { "http://example.com/images/item/#{id}.png" }
  end
end

