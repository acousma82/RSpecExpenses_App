require 'rack/test'
require 'json'
require 'ox'
require_relative '../../app/api'
require_relative '../../app/XML'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods
def app
    ExpenseTracker::API.new
end

def post_expense_json(expense)
    header "Content-Type", "application/json" 
    post '/expenses', JSON.generate(expense)
    expect(last_response.status).to eq(200)

    parsed = JSON.parse(last_response.body)
    expect(parsed).to include('expense_id' => a_kind_of(Integer))
    #adds an id key to the expense hash, containing the id from the database
    expense.merge('id' => parsed['expense_id'])
end

def create_xml(exp)
  
      Ox.default_options=({:with_xml => true})
      doc = Ox::Document.new(:version => '1.0')
      exp.each do |key, value|
      e = Ox::Element.new(key)
      e << value
      doc << e
    end
  xml =Ox.dump(doc)
  xml 
  end

# post the expense as xml data
def post_expense_xml(xml)
  #request header bekommt Content-type = xml
  header "Content-Type", "text/xml" 
  #expense daten werden alsl xml per Post request an den Server gesendet
  post '/expenses', xml
  #es wird erwartet das dies erfolgreich war
  expect(last_response.status).to eq(200)

  parsed = Ox.load(last_response.body, mode: :hash)
  expect(parsed).to include('expense_id' => a_kind_of(Integer))
  #adds an id key to the expense hash, containing the id from the database, after an expense is succesfully stored
  expense.merge('id' => parsed['expense_id'])
end

it 'records submitted expenses in JSON' do
        coffee = post_expense_json(
          'payee'  => 'Starbucks',
          'amount' => 5.75,
          'date'   => '2017-06-10'
        )
  
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
    coffee = post_expense_xml(%{<payee>Starbucks</payee>
            <amount>5.75</amount>
            <date>2017-06-10</date>})
      
    
    zoo = post_expense_xml(%{<payee>Zoo</payee>
          <amount>15.25</amount>
          <date>2017-06-10</date>})

    groceries = post_expense_xml(%{<payee>Whole Foods</payee>
    <amount>95.20</amount>
    <date>2017-06-11</date>})

    header "Content-Type", "text/xml"
    get '/expenses/2017-06-10'
    expect(last_response.status).to eq(200)

    expenses = Ox.load(last_response.body, mode: :hash)
    expect(expenses).to contain_exactly(coffee, zoo)
  end
end
end
