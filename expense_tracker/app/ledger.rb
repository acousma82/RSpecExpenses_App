#ledger class is like a rails model to communicate with the database
module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
    end
    def expenses_on(date)
    end
  end
  
end
