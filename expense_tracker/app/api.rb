require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    #:ledger with default value Ledger.new is an instance of the Ledger class which communicates with the database(it records, retrieves etc.)
    # Pseudocode for what happens inside the API class:
    #result = @ledger.record({ 'some' => 'data' })
    #result.success?      => a Boolean
    #result.expense_id    => a number
    #result.error_message => a string or nil
    #the code means that every time the expense_tracker Api is started/initialized a ledger instance is created which communicates with the database
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      JSON.generate(@ledger.expenses_on(params[:date]))
    end
  end
end
