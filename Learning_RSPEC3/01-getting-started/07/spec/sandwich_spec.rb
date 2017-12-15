#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
Sandwich = Struct.new(:taste, :toppings)

RSpec.describe 'An ideal sandwich' do
  def sandwich
    @sandwich ||= Sandwich.new('delicious', []) # when called  sandwich looks for an already defined @sandwich variable if it exists it doesn't create a new Sandwich instance. Once the def sandwich  is called @sandwich stores an Sandwich instance and no further instances are created inside the examples. this is called automatic memoization. another way would be to leave the || operator and store a sandwich instance  in a local variable at the beginning of the example. === @sandwich = @sandwich || Sandwich.new("delicious", [])
  end

  it 'is delicious' do
    taste = sandwich.taste

    expect(taste).to eq('delicious')
  end

  it 'lets me add toppings' do
    sandwich.toppings << 'cheese'
    toppings = sandwich.toppings

    expect(toppings).not_to be_empty
  end
end
