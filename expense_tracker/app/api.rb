require 'sinatra/base'
require 'json'
require 'ox'
require_relative 'ledger'
require_relative 'XML'
require "byebug"

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


  def create_xml(expenses)
    Ox.default_options=({:with_xml => true})
    doc = Ox::Document.new(:version => '1.0')
    if expenses.empty?
      exp = Ox::Element.new("expenses")
      xml = doc << exp
    else
      xml = expenses.inject(doc) { |acc, expense| acc << create_nodes(expense) }
    end
    Ox.dump(xml)
  end

  def create_nodes(expense)
    exp = Ox::Element.new("expense")
    expense.each do |key, value|
      e = Ox::Element.new(key)
      if value.is_a? String
        e << value
      elsif value.kind_of? Date
        e << value.strftime("%Y-%m-%d")
      else
        e << value.to_s
      end
      exp << e
    end
    exp
  end
# von Paul xml = expense.inject(doc) {|acc, exp| acc << Ox::Element.new(exp) }
def create_xml_single(exp)
  
      Ox.default_options=({:with_xml => false})
      doc = Ox::Document.new(:version => '1.0')
      exp.each do |key, value|
      e = Ox::Element.new(key)
      e << value.to_s
      doc << e
    end
  xml =Ox.dump(doc)
  xml 
  end
    post '/expenses' do
      if request.media_type == 'application/json'
      #die expense daten werden im json format gesendet und in einen Array übersetzt
        expense = JSON.parse(request.body.read)
      #Das Ergebnis wird mit ledger.record in der Datenbank gespeichert
        result = @ledger.record(expense)
        #request response dependent on whether the request was a success
        if result.success?
          headers \
              'Content-Type' => 'application/json'
          JSON.generate('expense_id' => result.expense_id)
        else
          status 422
          headers \
            'Content-Type' => 'application/json'
          JSON.generate('error' => result.error_message)
        end

      elsif request.media_type == 'text/xml'
        expense = Ox.load(request.body.read, mode: :hash)
        result = @ledger.record(expense)
        if result.success?
          headers \
            'Content-Type' => 'text/xml'
            create_xml_single('expense_id' => result.expense_id)
        else
          status 422
          headers \
            'Content-Type' => 'text/xml'
          create_xml_single('error' => result.error_message)
        end
      end
    end

    get '/expenses/:date' do
      if request.media_type == 'application/json'
        headers \
        'Content-Type' => 'application/json'
        JSON.generate(@ledger.expenses_on(params[:date]))
      elsif request.media_type == 'text/xml'
        headers \
        'Content-Type' => 'text/xml'
        create_xml(@ledger.expenses_on(params[:date]))
      end
    end
  end
end
