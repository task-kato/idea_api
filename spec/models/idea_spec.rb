require 'rails_helper'

RSpec.describe Idea, type: :model do
    describe 'バリデーション' do
        let(:category) { create(:category) }

        example 'FactoryBotがエラーを返さない' do
            idea = build(:idea, category_id: category.id)
            expect(idea).to be_valid
        end

        example 'bodyがnilの時エラー' do
            idea = build(:idea, body: nil)
            expect(idea).to be_invalid
        end

        example 'category_idがnilの時エラー' do
            idea = build(:idea, category_id: nil)
            expect(idea).to be_invalid
        end
    end
end