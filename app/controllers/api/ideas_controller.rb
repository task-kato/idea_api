class Api::IdeasController < ApplicationController
    def create
        idea_registration_form = IdeaRegistrationForm.new(idea_registration_params)
        if idea_registration_form.valid?
            idea_registration_form.save!
            render json: { status: 201, message: "created" }
        else
            render json: { status: 422, message: "unprocessable_entity" }
        end
    end

    def search
        idea_search_form = IdeaSearchForm.new(idea_search_params)
        # category_nameがnilもしくは該当するcategory_nameが存在する場合
        if !idea_search_form.category_name.present? || saved_category_name.present?
            idea_list = idea_search_form.get_idea_list
            render json: { data: idea_list }
        else
            render json: { status: 404, message: "not_found" }
        end
    end


    private

    def idea_registration_params
        params.permit(:category_name, :body)
    end

    def idea_search_params
        params.permit(:category_name)
    end

    def saved_category_name
        Category.find_by(name: params[:category_name])
    end

end
