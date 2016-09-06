class Item < ApplicationRecord
  belongs_to :category, optional: true
end
