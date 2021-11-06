class IdeaForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :category_name, :string
    attribute :body, :string

    validates :category_name, presence: true
    validates :body, presence: true

    def save!
        return if invalid?
        duplicate_category = Category.find_by(name: category_name)
        if duplicate_category
            idea = Idea.new(category_id: duplicate_category.id, body: body)
            idea.save! if valid?
        else
            new_category = Category.new(name: category_name)
            new_category.save! if valid?
            Idea.create!(category_id: new_category.id, body: body)
        end
    end

end