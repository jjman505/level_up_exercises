def Dinosaur(item)
  return item if item.is_a? Dinosaur
  return Dinosaur.new(item) if item.is_a? Hash
  raise TypeError, "Cannot convert #{item.inspect} to Dinosaur"
end

class Dinosaur
  DINOSAUR_ATTRS = [ :name, :period, :continent, :diet, :weight, :walking,
                     :description ].freeze unless defined?(DINOSAUR_ATTRS)

  attr_accessor *DINOSAUR_ATTRS

  CARNIVOROUS_DIETS = [ "Carnivore", "Insectivore", "Piscivore" ]

  def initialize(attrs = {})
    attrs.each { |key, val| send("#{key}=", val) }
  end

  def ==(other)
    TRAITS.all? { |attr| other.send(attr) == self.send(attr) }
  end

  def attr_hash
    hash = {}
    TRAITS.each { |attr| hash.merge!(attr => self.send(attr)) }
    hash
  end

  def to_s
    attr_hash.map do |attr, val|
      "#{attr.to_s.capitalize}: #{val.to_s}" unless val.nil?
    end.compact.join("\n")
  end

  def carnivore?
    CARNIVOROUS_DIETS.include?(diet)
  end

  def biped?
    walking.eql? "Biped"
  end

  #TODO: is there a better way?
  def from?(target_period)
    target_period = target_period.to_s.gsub('_', ' ')
    period =~ /#{target_period}/i
  end

  def heavy?
    weight && weight > 4000
  end

  def light?
    weight && weight <= 4000
  end
end

