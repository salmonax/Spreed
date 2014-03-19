require 'green_shoes'
require './lib/spreed_book'
require './lib/wpm'
require './lib/spreeder'

def repeat_every(interval)
  Thread.new do
    loop do
      start_time = Time.now
      yield
      elapsed = Time.now - start_time
      sleep([interval - elapsed, 0].max)
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

Shoes.app height: 250, title: "Spreed" do
    f = File.open("data/my_books/tda.txt","r")
    @spreed_book = SpreedBook.new(f)
    @reading_speed = Wpm.new(1000)

    @shoes_updater = Proc.new do
      @word.replace("")
      @position.replace("")
      @spreeder_slot.clear { @word = title "", align: 'center' }
      @position_slot.clear { @position = para "", align: 'right' }

      @thread = repeat_every @reading_speed.interval do 
        @word.replace(spreeded_output(@spreed_book.next_word))
        @time_left.replace("Time Left: #{@spreeder.hours_left} hours, #{@spreeder.minutes_left} minutes.")
        @position.replace("#{@spreed_book.current_position}/#{@spreed_book.length}")
      end
    end

    @spreeder =  Spreeder.new(@spreed_book,@reading_speed,&@shoes_updater)

    @display_slot = stack width: 875, margin_left: 25, margin_top: 10 do #width: 375 when @word margin_left is 0
      # background gray
      image "data/alignment_bar_top.png"
      @spreeder_slot = stack margin_left: -200 do
        @word = title "", align: 'center'
      end
      image "data/alignment_bar_bottom.png"
      @position_slot = flow width: 545 do
        @time_left = para "", align: 'left'
        @position = para "", align: 'right'
      end
    end

    flow margin_top: 20, margin_left: 140 do
      flow do
        @open_file = button "Open"
        list_box width: 90, items: ["50wpm","300wpm","600wpm",@reading_speed.text], choose: @reading_speed.text do |list|
          @reading_speed.set_from_text(list.text)
          @spreeder.start
        end
        @start_spreeding = button "Start"
        @stop = button "Stop"
        @back = button "Back 30"
        # @file_selected = para 'No file selected'
      end
    end

    @spreeder.start

    # spreeder = Spreeder.new(@spreed_book,@reading_speed,spreeder_slot)
    # spreeder_stack = stack
    

    @open_file.click do 
      f = File.open(ask_open_file(),"r")
      @spreed_book = SpreedBook.new(f)
    end

    @start_spreeding.click { @spreeder.start } 
    @stop.click { @spreeder.stop }
    @back.click { @spreeder.back(30) }



end