require 'rack/test'
require 'json'
require 'ox'
require 'byebug'
require_relative '../../app/api'
require_relative '../../app/XML'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods
def app
    ExpenseTracker::API.new
end

# creates an xml formatted String. Single element. No root Tags.
def create_xml_single(expense)
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
# creates an xml formatted String. Multiple elements. Creates the root tag 'expense' for each element. 

def post_expense_json(expense)
    header "Content-Type", "application/json" 
    post '/expenses', JSON.generate(expense)
    expect(last_response.status).to eq(200)

    parsed = JSON.parse(last_response.body)
    expect(parsed).to include('expense_id' => a_kind_of(Integer))
    #adds an id key to the expense hash, containing the id from the database
    expense.merge('id' => parsed['expense_id'])
end

<<<<<<< HEAD
# post the expense as an xml document/string, goal: the expense can  be posted as a hash
def post_expense_xml(expense, pay, amo, dat) #the best 
=======

# post the expense as xml data
def post_expense_xml(expense)
>>>>>>> b4463bcd9c85b8f14eeaed6c61d804930b145295
  #request header bekommt Content-type = xml
  header "Content-Type", "text/xml" 
  #expense daten werden alsl xml per Post request an den Server gesendet
  xml = create_xml_single(expense)
  post '/expenses', xml
  #es wird erwartet das dies erfolgreich war
  
  expect(last_response.status).to eq(200)

<<<<<<< HEAD
  parsed = # #a hash out of the (last_response.body)(in xml). But how to do this?
  expect(parsed).to include('expense_id' => a_kind_of(Integer))
  #adds an id key to the expense hash, containing the id from the database
  xml_expense_hash = #a hash out of the expense_xml_data generated with Ox. goal: this is not needed, becuse the expense_hash is there already.
  #adds an id key to the expense hash, containing the id from the database
  xml_hash.merge('id' => parsed['expense_id'])
=======
  parsed = Ox.load(last_response.body, mode: :hash)
  expect(parsed).to include('expense_id' => anything)
  #adds an id key to the expense hash, containing the id from the database, after an expense is succesfully stored
  expense.merge('id' => parsed['expense_id'])

>>>>>>> b4463bcd9c85b8f14eeaed6c61d804930b145295
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
    coffee = post_expense_xml(
      'payee'  => 'Starbucks',
      'amount' => '5.75',
      'date'   => '2017-06-10'
    )

    zoo = post_expense_xml(
      'payee'  => 'Zoo',
      'amount' => '15.25',
      'date'   => '2017-06-10'
    )

    groceries = post_expense_xml(
      'payee'  => 'Whole Foods',
      'amount' => '95.20',
      'date'   => '2017-06-11'
    )

    header "Content-Type", "text/xml"
    get '/expenses/2017-06-10'
    expect(last_response.status).to eq(200)
    expenses = Ox.load(last_response.body, mode: :hash)
    expect(expenses).to contain_exactly([ "expense",[coffee, zoo]])
  end
end
end
