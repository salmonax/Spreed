class SpreedBook
  attr_reader :book
  def initialize(f)
    @book = build_stripped_book(f)
    @current_position = 0
  end

  def current_position
    @current_position
  end

  def jump(words)
    @current_position = [0,@current_position + words].max
  end

  def next_word
    @current_position += 1
    @book[@current_position-1]
  end

  def word
    @book[@current_position]
  end

  def words_left
    @book.length - @current_position
  end

  def length
    @book.length
  end 

  private

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
end