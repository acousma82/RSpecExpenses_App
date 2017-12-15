#---
# Excerpted from "Effective Testing with RSpec 3",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rspec3 for more book information.
#---
class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    1.00 + ingredients.size * 0.25
  end

  def color
    ingredients.include?(:milk) ? :light : :dark
  end

  def temperature
    ingredients.include?(:milk) ? 190.0 : 205.0
    
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.filter_run_when_matching(focus:true) # with this config line rspec will only run the focused examples (examples with an f before the context/describe)
end

RSpec.describe 'A cup of coffee' do
  let(:coffee) { Coffee.new }

  it 'costs $1' do
    expect(coffee.price).to eq(1.00)
  end

  context 'with milk' do   # fcontext is a shortcut for context "with milk", focus: true do ... the hash value key pair is metadata you can add after decsibe context or it followed by  a do
    before { coffee.add :milk }

    it 'costs $1.25' do
      expect(coffee.price).to eq(1.25)
    end
    # marking WIP with pending. When the test is run these two will be marked as pending and not yet implemented. any lines before the pending keyword will still be expected to pass.the code which is marked pending is not iplented in the software yet. rspec will print the failure but it will not ,mark the overall suite as failing. when the code is implemented and the tests pass rspec lets us know that it expected the test to fail and raises two exceptions
    it 'is light in color' do
      pending 'Color not implemented yet'
      expect(coffee.color).to be(:light)
    end

    it 'is cooler than 200 degrees Fahrenheit' do
      pending 'Temperature not implemented yet'
      expect(coffee.temperature).to be < 200.0
    end

  end
end
