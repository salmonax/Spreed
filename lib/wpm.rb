class Wpm
  attr_reader :wpm
  
  def initialize(wpm)
    @wpm = wpm
  end

  def interval
    60/@wpm.to_f
  end

  def text
    @wpm.to_s + "wpm"
  end

  def set(wpm)
    @wpm = wpm
  end

  def set_from_text(text)
    @wpm = text.gsub(/\a/,'').to_i
  end
end