require 'green_shoes'
require './lib/spreed_book'
require './lib/wpm'
require './lib/spreeder'

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

  def stop 
    @slot.app do
       @spreed_loop.stop
    end
  end

end

def spreedify(word)
  return if word == nil
  position = word.length == 1 ? 0 : (word.length/4.0+1).ceil-1
end

def spreeded_output(new_word)
  return if new_word == nil
  center = spreedify(new_word)
  red_letter = span fg new_word[center], red
  first_half = new_word[0...center]
  last_half = new_word[center+1..-1]
  leading = span fg last_half, white
  trailing = span fg first_half, white
  output_text = leading + first_half + red_letter + last_half + trailing
  output_text = new_word if new_word == "&amp;"
  output_text
end

Shoes.app height: 240, title: "Spreed" do

    f = File.open("data/my_books/db.txt","r")
    @spreed_book = SpreedBook.new(f)
    @reading_speed = Wpm.new(500)

    @shoes_outputter = ShoesOutputter.new(stack)
    @spreeder =  Spreeder.new(@spreed_book,@reading_speed,@shoes_outputter)

    @display_slot = stack width: 875, margin_left: 25, margin_top: 10 do
      image "data/alignment_bar_top.png"
      @spreeder_slot = stack margin_left: -200 do
        @word = title "", align: 'center'
      end
      image "data/alignment_bar_bottom.png"
      @position_slot = flow width: 645 do
        @time_left = para "", align: 'left'
        @position = para "", align: 'left'
        @info = para fg "0-9 to set speed. Q for Play/Pause. I to hide info.", blue
      end
    end

    @spreeder.start

    keypress do |k|
      puts "#{k.inspect} was PRESSED."
      case k.to_i
      when 1..9
        @spreeder.set_speed(k.to_i*100)
      end
      case k
      when "0"
        @spreeder.set_speed(1000)
      when "q"
        @spreeder.toggle
      when "w"
        @spreeder.back(100)
      when "e"
        @spreeder.forward(100)
      when "s"
          @spreeder.slower(50)
      when "d"
          @spreeder.faster(50)
      when "i"
          @info.toggle
      end

    end


end