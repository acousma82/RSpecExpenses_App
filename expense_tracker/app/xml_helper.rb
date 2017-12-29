require 'ox'
module ExpenseTracker

    class XML 
    
        def create_xml(exp)
        
            Ox.default_options=({:with_xml => false})
            doc = Ox::Document.new(:version => '1.0')
            exp.each do |key, value|
            e = Ox::Element.new(key)
            e << value
            doc << e
          end
        xml =Ox.dump(doc)
        xml 
        end
    end
end