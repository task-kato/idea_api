class Api::IdeasController < ApplicationController

    def create
        idea_registration_form = IdeaRegistrationForm.new(idea_registration_params)
        if idea_registration_form.valid?
            idea_registration_form.save!
            # status code 201
            render status: :created
        else
            # status code 402
            render status: :unprocessable_entity
        end
    end

    def ideas_search
        idea_search_form = IdeaSearchForm.new(idea_search_params)
        # category_nameがnilもしくは該当するcategory_nameがDBに存在する場合
        if !idea_search_form.category_name.present? || saved_category_name.present?
            idea_list = idea_search_form.get_idea_list
            render json: { data: idea_list }
        else
             # status code 404
            render status: :not_found
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
