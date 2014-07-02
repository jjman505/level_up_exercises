require 'csv'

class DinoCsv
  def self.read(filename, options = {})
    CSV.table(filename).map { |row| dino_hash(row, options) }
  end

  private

  def self.dino_hash(row, options)
    Hash[ row.map { |k, v| convert(k, v, options) } ]
  end

  def self.convert(k, v, options = {})
    return BasicConverter.convert(k, v) unless options[:converter]
    case options[:converter]
    when :african
      AfricanConverter.convert(k, v)
    end
  end

  class Converter
    CONVERSIONS = Hash.new { |_, k| k }

    def self.convert(key, value)
      [ CONVERSIONS[key] || key, CONVERSIONS[value] || value ]
    end
  end

  class BasicConverter < Converter
    # TODO: better way to merge?
    CONVERSIONS.merge!(:weight_in_lbs => :weight)
  end

  class AfricanConverter < Converter
    # TODO: better way to merge?
    CONVERSIONS.merge!(:genus => :name)

    DIET_CONVERSIONS = {
      "Yes" => "Carnivore",
      "No" => "Herbivore"
    }

    def self.convert(key, value)
      if key =~ /carnivore/i
        [ :diet, convert_diet(value) ]
      else
        super
      end
    end

    def self.convert_diet(value)
      DIET_CONVERSIONS[value]
    end
  end
end

