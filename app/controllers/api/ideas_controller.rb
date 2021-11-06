class Api::IdeasController < ApplicationController
    def create
        idea_form = IdeaForm.new(idea_registration_params)
        if idea_form.valid?
            idea_form.save!
            render json: { status: 201, message: "created" }
        else
            render json: { status: 422, message: "unprocessable_entity" }
        end
    end

    def search

    end


    private

    def idea_registration_params
        params.permit(:category_name, :body)
    end

end
