require 'time'

class IdeaSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category_name, :string

  def idea_list
    if category_name.present?
      category = Category.find_by(name: category_name)
      idea_list = Idea.where(category_id: category.try(:id))
    else
      idea_list = Idea.all
    end
    arrange_idea_list_array(idea_list)
  end

  private

  def arrange_idea_list_array(idea_list)
    idea_list_array = []
    idea_list.each do |idea|
      idea_list_array.push({
           "id": idea.id,
           "category": idea.category.name,
           "body": idea.body,
           "created_at": Time.parse(idea.created_at.to_s).to_i
       })
    end
    idea_list_array
  end
end
