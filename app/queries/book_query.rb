class BookQuery
  def initialize(scope = Book.all)
    @scope = scope
  end
  
  def search(query)
    scope = @scope
    return scope if query.blank?
    
    scope = scope.where("title like ?", "%#{query[:title]}%") if query[:title].present?
    scope = scope.where("author like ?", "%#{query[:author]}%") if query[:author].present?
    scope = scope.where(genre: query[:genre]) if query[:genre].present?
    
    scope
  end
end