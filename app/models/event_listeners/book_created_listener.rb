class BookCreatedListener
  def listen_to(event)
    if event.is_a? BookCreated
      book = Book.new(id: event.aggregate_id, title: event.title, author: event.author)
      book.save
    end
    self
  end
end