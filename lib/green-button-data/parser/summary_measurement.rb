module GreenButtonData
  module Parser
    class SummaryMeasurement
      include SAXMachine
      include Enumerations

      element :powerOfTenMultiplier, class: Integer,
              as: :power_of_ten_multiplier
      element :timeStamp, as: :time_stamp
      element :uom, class: Integer
      element :value, class: Integer
      element :readingTypeRef, as: :reading_type_ref
      element :note
      element :itemKind, class: Integer, as: :item_kind

      def power_of_ten_multiplier
        UNIT_MULTIPLIER[@power_of_ten_multiplier]
      end

      def uom
        UNIT_SYMBOL[@uom]
      end

      def raw_value
        @value
      end

      def value
        @value * 10.0 ** @power_of_ten_multiplier
      end

      def to_s
        "#{value} #{uom.to_s}"
      end

      # ESPI Namespacing
      element :'espi:powerOfTenMultiplier', class: Integer,
              as: :power_of_ten_multiplier
      element :'espi:timeStamp', as: :time_stamp
      element :'espi:uom', class: Integer, as: :uom
      element :'espi:value', class: Integer, as: :value
      element :'espi:readingTypeRef', as: :reading_type_ref
      element :'espi:note', as: :note
      element :'espi:itemKind', class: Integer, as: :item_kind

      # Special case for PG&E generic namespacing
      element :'ns0:powerOfTenMultiplier', class: Integer,
              as: :power_of_ten_multiplier
      element :'ns0:timeStamp', as: :time_stamp
      element :'ns0:uom', class: Integer, as: :uom
      element :'ns0:value', class: Integer, as: :value
      element :'ns0:readingTypeRef', as: :reading_type_ref
      element :'ns0:note', as: :note
      element :'ns0:itemKind', class: Integer, as: :item_kind

    end
  end
end
