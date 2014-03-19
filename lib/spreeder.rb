class Spreeder
  def initialize(book,speed,&updater)
    @book = book
    @speed = speed
    @updater = updater
  end

  def start
    if @thread
      sleep(0.1)
      @thread.kill
    end
    @thread = @updater.call
  end

  def stop
    @thread.kill if @thread
    @thread = nil
  end

  def word
    @book.word
  end

  def back(words)
    @book.jump_back(words)
    self.start
  end

  def hours_left 
    (@book.words_left/@speed.wpm)/60
  end

  def minutes_left
    (@book.words_left/@speed.wpm)%60
  end
end