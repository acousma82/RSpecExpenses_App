require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
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

  def post_expense_json(expense)
    header "Content-Type", "application/json"
    post '/expenses', JSON.generate(expense)
  end

  def parsed_last_response_json
    JSON.parse(last_response.body)
  end

  def post_expense_xml(expense)
    header "Content-Type", "text/xml"
    post '/expenses', create_xml_single(expense)
  end

  def parsed_last_response_xml
    Ox.load(last_response.body, mode: :hash)
  end

 

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id in json when expense posted in json' do
          post_expense_json(expense)
          expect(parsed_last_response_json).to include('expense_id' => 417)
        end
        it 'returns the expense id in xml when expense posted in xml' do
          post_expense_xml(expense)
          expect(parsed_last_response_xml).to include('expense_id' => "417")
        end

        it 'responds with a 200 (OK) when expense posted in json' do
          post_expense_json(expense)
          expect(last_response.status).to eq(200)
        end
        it 'responds with a 200 (OK) when expense posted in xml' do
          post_expense_xml(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let(:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message in json' do
          post_expense_json(expense)
          expect(parsed_last_response_json).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity) in json' do
          post_expense_json(expense)
          expect(last_response.status).to eq(422)
        end

        it 'returns an error message in xml' do
          post_expense_xml(expense)
          expect(parsed_last_response_xml).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity) in xml' do
          post_expense_xml(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

#alle get requests für json und xml header testen
    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        let(:expense_1) { { "id"=> "42", "payee"=>"Starbucks", "amount"=>"5.75", "date"=>"2017-06-12"} }
        let(:expense_2) { { "id"=>"42", "payee"=>"StarFood", "amount"=>"575", "date"=>"2017-06-12"} }
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-12')
            .and_return([expense_1, expense_2])
        end

        it 'returns the expense records in JSON format when request header is set to json' do
          header "Content-Type", "application/json"
          get '/expenses/2017-06-12'
          expect(parsed_last_response_json).to eq([expense_1, expense_2])
        end

        it 'returns the expense records in XML format when request header is set to xml' do
          header "Content-Type", "text/xml"
          get '/expenses/2017-06-12'
          expect(parsed_last_response_xml).to eq("expense" => [expense_1, expense_2])
        end

        it 'responds with a 200 (OK) in JSON format when request header is set to json' do
          header "Content-Type", "application/json"
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end

        it 'responds with a 200 (OK) in XML format when request header is set to xml' do
          header "Content-Type", "text/xml"
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        before do
          allow(ledger).to receive(:expenses_on)
            .with('2017-06-12')
            .and_return([])
        end

        it 'returns an empty array as JSON' do
          header "Content-Type", "application/json"
          get '/expenses/2017-06-12'
          expect(parsed_last_response_json).to eq([])
        end

        it 'returns an empty array as XML' do
          header "Content-Type", "text/xml"
          get '/expenses/2017-06-12'
          expect(parsed_last_response_xml).to eq("expenses" => nil)
        end

        it 'responds with a 200 (OK) JSON' do
          header "Content-Type", "application/json"
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end

        it 'responds with a 200 (OK) XML' do
          header "Content-Type", "text/xml"
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
      end
    end
    end
  end
end
