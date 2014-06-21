def Dinosaur(item)
  if item.is_a? Dinosaur
    Dinosaur.new(item.attr_hash)
  elsif item.is_a? Hash
    Dinosaur.new(item)
  else
    raise WrongArgumentTypeError
  end
end

class Dinosaur
  TRAITS = [ :name, :period, :continent,
             :diet, :weight, :walking, :description ]

  attr_accessor *TRAITS

  CARNIVOROUS_DIETS = [ "Carnivore", "Insectivore", "Piscivore" ]

  def initialize(dino_hash = {})
    dino_hash.each { |key, val| send("#{key}=", val) }
  end

  def ==(other)
    TRAITS.each { |attr| return false if other.send(attr) != self.send(attr) }
  end

  def attr_hash
    TRAITS.map { |attr| [attr, self.send(attr)] }.to_h
  end

  def to_s
    defined_attributes = attr_hash.select { |_, val| val != nil }
    defined_attributes.reduce("") do |str, (attr, val)|
      str << "#{attr.to_s.capitalize}: #{val.to_s}\n"
    end.chomp
  end

  def carnivore?
    CARNIVOROUS_DIETS.include?(@diet)
  end

  def biped?
    @walking.eql? "Biped"
  end

  #TODO: is there a better way?
  def from?(period)
    @period.downcase.include?(period.to_s.tr('_', ' '))
  end

  def heavy?
    @weight && @weight > 4000
  end

  def light?
    @weight && @weight < 4000
  end
end

