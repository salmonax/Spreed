require 'green_shoes'
require './lib/spreed_book'
require './lib/wpm'

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

Shoes.app height: 195, title: "Spreed" do
    flow height: 20 do
      background white
      # @file_selected = para 'No file selected'
      # @open_file = button "Open File"
      # @start_spreeding = button "Start Spreeding!"
      # @stop = button "Stop!"
    end

    # @open_file.click do
    #   @file_selected.replace ask_open_file()
    # end

    # @start_spreeding.click do

    # end

    # @stop.click do
    #   Thread.kill(thread)
    # end
    
    stack width: 875, margin_left: 20 do #width: 375 when @word margin_left is 0
      image "data/alignment_bar_top.png"
      flow margin_left: -200 do
        @word = title "", align: 'center'
      end
      image "data/alignment_bar_bottom.png"
    end

    stack width: 560 do
      @position = para "", align: 'right'
    end
    word_position = 0


    reading_speed = Wpm.new(600) 
    f = File.open("data/books/gutenberg_the_idiot.txt","r")
    @spreed_book = SpreedBook.new(f)

    every reading_speed.interval do
      @word.replace(spreeded_output(@spreed_book.next_word))
      hours_to_read = (@spreed_book.words_left/reading_speed.wpm)/60
      minutes_to_read = (@spreed_book.words_left/reading_speed.wpm)%60
      @position.replace(hours_to_read.to_s+" hours, "+minutes_to_read.to_s+" minutes.    "+@spreed_book.current_position.to_s + "/" + @spreed_book.length.to_s)
    end

end