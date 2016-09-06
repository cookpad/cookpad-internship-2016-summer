require 'rails_helper'

RSpec.feature "Order items", type: :feature do

  scenario 'A user can order 2 hochyo' do
    kitchenware = create(:category, name: '調理器具')
    create(:item, category: kitchenware, name: '包丁', price: 3_000)

    visit root_path

    click_on '調理器具'
    click_on '包丁'

    fill_in  '数量', with: '2'
    click_on 'カートに追加'

    expect(page).to have_content('ご注文ありがとうございました')
    expect(page).to have_content(%r!注文日時: \d{4}/\d{2}/\d{2} \d{2}:\d{2}!)

    expect(page).to have_css('.line_items td', text: '包丁')
  end

  scenario 'A user can order 2 hochyo & 1 pot' do
    kitchenware = create(:category, name: '調理器具')
    create(:item, category: kitchenware, name: '包丁', price: 3_000)
    create(:item, category: kitchenware, name: '鍋',   price: 2_500)

    visit root_path

    click_on '調理器具'
    click_on '包丁'

    fill_in  '数量', with: '2'
    click_on 'カートに追加'
    click_on '買い物を続ける'

    expect(page.current_path).to eq('/')

    click_on '調理器具'
    click_on '鍋'

    fill_in   '数量', with: '1'
    click_on 'カートに追加'
    click_on '注文を確定する'

    expect(page).to have_content('ご注文ありがとうございました')
    expect(page).to have_content(%r!注文日時: \d{4}/\d{2}/\d{2} \d{2}:\d{2}!)

    expect(page).to have_css('.line_items td', text: '包丁')
    expect(page).to have_css('.line_items td', text: '鍋')
  end
end
