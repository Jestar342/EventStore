class BookReturned
  include EventStore::Event

  def replay (book)
    book.available= true
  end
end