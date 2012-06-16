class BookBorrowed
  include EventStore::Event

  def replay (book)
    book.available= false
  end
end