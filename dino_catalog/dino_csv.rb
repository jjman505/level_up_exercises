require 'csv'

class DinoCSV
  def self.read(filename)
    CSV.table(filename).map do |row|
      row.reduce({}) do |hash, (k, v)|
        hash.merge({ normalize_header(k) => normalize_cell(v) })
      end
    end
  end

  private

  def self.normalize_header(item)
    normalize_data_item(item, {
      :genus => :name,
      :carnivore => :diet,
      :weight_in_lbs => :weight
    })
  end

  def self.normalize_cell(item)
    normalize_data_item(item, {
      "yes" => "Carnivore",
      "no" => "Herbivore"
    })
  end

  def self.normalize_data_item(item, conversions)
    (item.respond_to?(:downcase) && conversions[item.downcase]) || item
  end
end

