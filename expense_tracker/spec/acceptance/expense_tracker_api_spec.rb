require 'rack/test'
require 'json'
require 'ox'
require_relative '../../app/api'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods
def app
    ExpenseTracker::API.new
end

def post_expense(expense)
    header "Content-Type", "application/json" 
    post '/expenses', JSON.generate(expense)
    expect(last_response.status).to eq(200)

    parsed = JSON.parse(last_response.body)
    expect(parsed).to include('expense_id' => a_kind_of(Integer))
    #adds an id key to the expense hash, containing the id from the database
    expense.merge('id' => parsed['expense_id'])
end
def create_xml(expense, pay, amo, dat)
  Ox.default_options=(:with_xml => true)
  doc = Ox::Document.new(:version => '1.0')
  
  expense =  Ox::Element.new("#{expense}")
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
  xml = Ox.dump(xml)
end

# post the expense as an xml data
def post_expense_xml(expense, pay, amo, dat)
  #request header bekommt Content-type = xml
  header "Content-Type", "application/xml" 
  #xml dokument wird erstellt
  xml = create_xml(expense, pay, amo, dat)
  #expense daten werden als xml per Post request an den Server gesendet
  post '/expenses', xml
  #es wird erwartet das dies erfolgreich war
  expect(last_response.status).to eq(200)

  parsed = # #a hash out of the (last_response.body)(in xml). But how to do this?
  expect(parsed).to include('expense_id' => a_kind_of(Integer))
  #adds an id key to the expense hash, containing the id from the database
  xml_expense_hash = #a hash out of the expense_xml_data generated with Ox
  xml_hash.merge('id' => parsed['expense_id'])
end

it 'records submitted expenses in JSON' do
    coffee = {
          'payee'  => 'Starbucks',
          'amount' => 5.75,
          'date'   => '2017-06-10'
  }
        
  
        zoo = post_expense_json(
          'payee'  => 'Zoo',
          'amount' => 15.25,
          'date'   => '2017-06-10'
        )
  
        groceries = post_expense_json(
          'payee'  => 'Whole Foods',
          'amount' => 95.20,
          'date'   => '2017-06-11'
        )
  
    get '/expenses/2017-06-10'
    expect(last_response.status).to eq(200)

    expenses = JSON.parse(last_response.body)
    expect(expenses).to contain_exactly(coffee, zoo)
  end

  it "records submitted expenses in xml" do
    
      

      zoo = post_expense_xml(
        'payee'  => 'Zoo',
        'amount' => 15.25,
        'date'   => '2017-06-10'
      )

      groceries = post_expense_xml(
        'payee'  => 'Whole Foods',
        'amount' => 95.20,
        'date'   => '2017-06-11'
      )

    get '/expenses/2017-06-10'
    expect(last_response.status).to eq(200)

    expenses = FIll_IN(last_response.body)
    expect(expenses).to contain_exactly(coffee, zoo)
  end
end
end
