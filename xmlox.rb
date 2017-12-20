require 'ox'

doc = Ox::Document.new(:version => '1.0')

expense = Ox::Element.new('expense')
doc << expense
top = Ox::Element.new('payee')
top << 'Starbucks'
expense << top

mid = Ox::Element.new('amount')
mid << '5.75'
expense << mid

bot = Ox::Element.new('date')
bot << '2017-06-10'
expense << bot

xml = Ox.dump(doc)
puts xml