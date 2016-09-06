FactoryGirl.define do
  factory :category do
    name "雑貨"
    image_url   { "http://example.com/images/category/#{id}.png" }
  end
end

