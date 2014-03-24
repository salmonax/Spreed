require 'rspec'
require 'spreed_book'

describe 'spreed_book' do
  let(:data) { "This is the second greatest book ever written."}
  let(:result) { ["This", "is", "the", "second", "greatest", "book", "ever", "written."] }
  let(:spreed_book) { SpreedBook.new(StringIO.new(data)) }

  context '#initialize' do
    it 'initializes a spreed book object' do
      spreed_book.should be_an_instance_of SpreedBook 
    end

    it 'strips the file and stores in array' do
      spreed_book.book.should eq result
    end
  end



end