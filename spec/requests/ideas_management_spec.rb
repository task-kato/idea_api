require 'rails_helper'
require "json"

RSpec.describe 'Api::Ideas', type: :request do

  describe 'POST api/ideas' do
    let(:param_hash) { attributes_for(:idea) }
    let(:invalid_param_hash) { attributes_for(:idea, :invalid)}

    describe 'アイデア登録' do
      # カテゴリーを事前に一つ作成
      let!(:category) { create(:category) }
      context '正常系' do
        example 'リクエストのcategory_nameがcategoriesテーブルのnameに存在する' do
          # 登録されているカテゴリー名をリクエスト
          expect{ post api_ideas_url, params: param_hash.merge!(category_name: "test_category_name_1") }
          .to change(Category, :count).by(0) & change(Idea, :count).by(1)
          expect(response).to have_http_status 201
        end

        example 'リクエストのcategory_nameがcategoriesテーブルのnameに存在しない' do
          # 登録されていないカテゴリー名をリクエスト
          expect{ post api_ideas_url, params: param_hash.merge!(category_name: "unregistered_test_category_name") }
          .to change(Category, :count).by(1) & change(Idea, :count).by(1)
          expect(response).to have_http_status 201
        end
      end

      context '準正常系' do
        example 'リクエストのbodyのみがnil' do
          # 登録されているカテゴリー名をリクエスト
          expect{ post api_ideas_url, params: invalid_param_hash.merge!(category_name: "test_category_name_1") }
          .to change(Category, :count).by(0) & change(Idea, :count).by(0)
          expect(response).to have_http_status 422
        end

        example 'リクエストのcategory_nameのみがnil' do
          expect{ post api_ideas_url, params: param_hash.merge!(category_name: "") }
          .to change(Category, :count).by(0) & change(Idea, :count).by(0)
          expect(response).to have_http_status 422
        end
      end
    end
  end

  describe 'POST api/ideas_search' do
    let(:json) { JSON.parse(response.body) }
    let(:response_idea_list) { json["data"] }

    # テスト用のカテゴリーとアイデアを作成
    before { create_list(:category, 2) }
    let!(:first_category_idea) { create(:idea, category_id: Category.first.id) }
    let!(:last_category_idea) { create(:idea, category_id: Category.last.id) }

    let(:expected_first_idea_response_object) do
      {
        'id' => first_category_idea.id,
        'category' => "#{first_category_idea.category.name}",
        'body' => "#{first_category_idea.body}",
        'created_at' => Time.parse(first_category_idea.created_at.to_s).to_i
      }
    end

    let(:expected_last_idea_response_object) do
      {
        'id' => last_category_idea.id,
        'category' => "#{last_category_idea.category.name}",
        'body' => "#{last_category_idea.body}",
        'created_at' => Time.parse(last_category_idea.created_at.to_s).to_i
      }
    end

    describe 'アイデア取得' do
      context '正常系' do
        example 'DBに保存されているcategory_nameが指定されている場合' do
          post api_ideas_search_url, params: {category_name: Category.last.name}
          expect(response_idea_list[0]).to match(expected_last_idea_response_object)
          expect(response_idea_list[1]).to eq(nil)
        end

        example 'category_nameが指定されていない場合' do
          post api_ideas_search_url, params: {category_name: ""}
          expect(response_idea_list[0]).to match(expected_first_idea_response_object)
          expect(response_idea_list[1]).to match(expected_last_idea_response_object)
        end
      end

      context '準正常系' do
        example '登録されていないカテゴリーのリクエストを受けた場合' do
          post api_ideas_search_url, params: {category_name: "unregistered_test_category_name"}
          expect(response).to have_http_status 404
        end
      end
    end
  end

end