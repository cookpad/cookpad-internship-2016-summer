require 'rails_helper'

RSpec.describe "Order items via API", type: :request do
  let(:kitchenware) { create(:category, name: '調理器具') }

  let(:hocho) { create(:item, category: kitchenware, name: '包丁', price: 3_000) }
  let(:pot)   { create(:item, category: kitchenware, name: '鍋',   price: 2_500) }

  specify 'A client can POST whole order in one request' do
    post(
      orders_path,
      params: {
        line_items: [
          {item_id: hocho.id, quantity: 2},
          {item_id: pot.id,   quantity: 1},
        ]
      },
      as: :json
    )

    expect(response.status).to eq(201)
    expect(JSON.parse(response.body)['status']).to eq('checked_out')
  end
end
