require 'rack/test'
require 'json'
require 'active_support/core_ext'
require_relative '../../app/api'

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

def post_expense_xml(expense)
    header "Content-Type", "application/xml" 
    
    post '/expenses', Hash.to_xml(expense)
    expect(last_response.status).to eq(200)
  
    parsed = Ox.parse(last_response.body)
    expect(parsed).to include('expense_id' => a_kind_of(Integer))
    #adds an id key to the expense hash, containing the id from the database
    expense.merge('id' => parsed['expense_id'])
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
      coffee = post_expense_xml(
          'payee'  => 'Starbucks',
          'amount' => 5.75,
          'date'   => '2017-06-10'
        )
        
  
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
