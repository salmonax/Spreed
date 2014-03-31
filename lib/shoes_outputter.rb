# Shoes-specific outputter strategy for the Spreeder'
class ShoesOutputter

  def initialize(slot)
    @slot = slot
    @slot.app do
      #move the relevant instance variable here, eventually
    end
  end

  def start
    @slot.app do
      @spreed_loop = every @reading_speed.interval do 
        @word.replace(spreeded_output(@spreed_book.next_word))
        @time_left.replace("#{@spreeder.hours_left} hours, #{@spreeder.minutes_left} minutes.\
          #{@spreed_book.current_position}/#{@spreed_book.length}\
          #{@spreeder.wpm}wpm")
      end
    end
  end

  def save
    @slot.app do
      position_content = File.read(@position_filename)
      without_this_book = position_content.gsub(/#{@book_filename},[\d]+\n/,'')
      File.open(@position_filename,"w") { |file| file << without_this_book }
      output_line = "#{@book_filename},#{@spreed_book.current_position}\n"
      File.open(@position_filename,"a") { |file| file << output_line }
    end
  end 

  def load
    @slot.app do
      matched_lines = File.readlines(@position_filename).select { |line| line =~ /#{@book_filename},[\d]+\n/ }
      last_position = matched_lines[0].split(',')[1]
    end

  end

  def stop 
    @slot.app do
       @spreed_loop.stop
    end
  end

end
