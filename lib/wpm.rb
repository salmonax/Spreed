class Wpm
  def initialize(wpm)
    @wpm = wpm
  end
  def wpm
    @wpm
  end

  def interval
    bleh = 60/@wpm.to_f
  end
end