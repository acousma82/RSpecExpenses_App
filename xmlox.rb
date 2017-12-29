require 'ox'

doc = Ox::Document.new(:version => '1.0')


top = Ox::Element.new('payee')
top << 'Starbucks'
doc << top

mid = Ox::Element.new('amount')
mid << '5.75'
doc << mid

bot = Ox::Element.new('date')
bot << '2017-06-10'
doc << bot

xml = Ox.dump(doc)
puts xml