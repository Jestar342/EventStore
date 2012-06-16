class BookReturnedListener
  def listen_to(event)
    if event.instance_of? BookReturned
      book = Book.where(id: event.aggregate_id).first
      book.available = true
      book.save
    end
  end
end