class SpreedBook
  def initialize(f)
    @book = build_stripped_book(f)
    @current_position = 0
  end

  def current_position
    @current_position
  end

  def next_word
    @current_position += 1
    @book[@current_position-1]
  end

  def words_left
    @book.length - @current_position
  end

  def build_stripped_book(f)
    book = []
    f.each do |line| 
      line
      .gsub(%r(\n|\r|\&|&),'')
      .gsub(%r(—),'— ')
      .gsub(%r(-),'- ')
      .gsub(%r(/),'/ ')
      .split(' ').each do |word|
        book.push word
      end
    end
    book
  end

  def length
    @book.length
  end
end