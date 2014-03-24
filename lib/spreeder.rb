class Spreeder
  def initialize(book,speed,outputter)
    @book = book
    @speed = speed
    @outputter = outputter
    @running = false
  end

  def running?
    @running
  end

  def wpm
    @speed.wpm
  end


  def start
    # @speed.set
    if !@running
      @outputter.start
      @running = true
    end
  end

  def stop
   if @running
      @outputter.stop
      @running = false
   end
  end

  def toggle
    @running? self.stop : self.start
  end
    
  def set_speed(number)
    @speed.set(number)
    @outputter.stop
    @outputter.start if @running
  end

  def word
    @book.word
  end

  def back(words)
    @book.jump(-words)
    if @running
      @outputter.stop
      @outputter.start
    end
  end

  def forward(words)
    self.back(-words)
  end

  def faster(add)
    @speed.set(@speed.wpm+add)
    @outputter.stop
    @outputter.start if @running
  end

  def slower(add)
    self.faster(-add) if @speed.wpm-add > 0
  end


  def hours_left 
    (@book.words_left/@speed.wpm)/60
  end

  def minutes_left
    (@book.words_left/@speed.wpm)%60
  end
end