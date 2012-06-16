class BookBorrowedListener
  def listen_to (event)
    book = Book.where(id: event.aggregate_id).first
    book.available = false
    book.save
  end
end