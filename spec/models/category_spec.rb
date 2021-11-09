require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    let!(:category) { create(:category) }

    example 'FactoryBotがエラーを返さない' do
      idea = build(:category)
      expect(idea).to be_valid
    end

    example 'nameがnilの時エラー' do
      idea = build(:category, name: nil)
      expect(idea).to be_invalid
    end

    example 'すでにDB上にあるnameは登録できない' do
      idea = build(:category, name: category.name)
      expect(idea).to be_invalid
    end
  end
end
