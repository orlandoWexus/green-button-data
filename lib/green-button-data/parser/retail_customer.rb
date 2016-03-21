module GreenButtonData
  module Parser
    class RetailCustomer
      include SAXMachine

      element :Customer, as: :customer

      # ESPI Namespacing
      element :'espi:Customer', as: :customer

      # Special case for PG&E which uses generic namespacing
      element :'ns0:Customer', as: :customer
    end
  end
end
