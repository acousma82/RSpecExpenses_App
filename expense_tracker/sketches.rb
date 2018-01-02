coffee = post_expense_xml(
            <payee>Starbucks</payee>
            <amount>5.75</amount>
            <date>2017-06-10<7date>
          )



          require 'ox'

doc = Ox::Document.new(:version => '1.0')

expenses =  Ox::Element.new('expense')
doc << expenses

payee = Ox::Element.new('payee')
payee << 'starbucks'
expenses << payee

amount = Ox::Element.new('amount')
amount << '5.75'
expenses << amount

date = Ox::Element.new('date')
date << '2017-06-10'
expenses << date

xml = Ox.dump(doc)
puts xml
doc2 = Ox.parse(xml)
puts "Same? #{doc == doc2}"

ox_nodes.reduce({}) do |hash, node|
  hash[node.instance_variable_get('@value')] = node.text
  hash
end

ox_nodes.reduce({}) do |hash, node|
  hash.tap { |h| h[node.instance_variable_get('@value')] = node.string } 
end

expense =  {"payee"=>"starbucks", "amount"=>"5.75", "date"=>"2017-06-10"}

nimm jeden key des hashes als element value und jeden value des hashes als string des nodes array.
expense.each do
# creates an xml formatted String
def create_xml(expense)
  Ox.default_options=({:with_xml => true})
    doc = Ox::Document.new(:version => '1.0')
    expense.each do |key, value|
        e = Ox::Element.new(key)
        if value.is_a? String
            e << value
        else
            e << value.to_s
        end
        doc << e
    end
    Ox.dump(doc)
end

#
def parse_xml_to_hash(xml)
    Ox.load(xml: mode:hash)


    expense =  Ox::Element.new('#{expense}')
    doc << expense
    
    payee = Ox::Element.new('payee')
    payee << pay
    expense << payee
    
    amount = Ox::Element.new('amount')
    amount << amo
    expense << amount
    
    date = Ox::Element.new('date')
    date << dat
    expense << date



    case expense.key?(a) === false
    when "payee" 