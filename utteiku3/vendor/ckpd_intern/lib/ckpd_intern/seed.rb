require 'json'

module CkpdIntern
  class Seed
    JSON_PATH = File.dirname(__FILE__) + '/seeds.json'

    class << self
      def create_all!
        new(JSON_PATH).create_all!
      end
    end

    def initialize(seeds)
      @seeds = JSON.parse(File.read(seeds))
    end

    def create_all!
      [Category, Item].each(&:delete_all)

      item_fixed_id = 1

      @seeds.each.with_index(1) do |(category_name, data), index|
        category = Category.create!(name: category_name, image_url: data['image_path']) {|c| c.id = index }

        data['items'].each do |item|
          category.items.create!(name: item['title'], description: item['description'], image_url: item['image_path'], price: 1_000) {|i| i.id = item_fixed_id }
          item_fixed_id += 1
        end
      end

      Item.where('(id % 3) = 0').update_all(recommended: true)
    end

  end
end

