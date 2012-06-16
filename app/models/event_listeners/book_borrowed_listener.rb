class BookBorrowedListener
  def listen_to (event)
    if event.instance_of? BookBorrowed
      book = Book.where(id: event.aggregate_id).first
      book.available = false
      book.save
    end
  end
end