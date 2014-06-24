class Arrowhead

  # This seriously belongs in a database.
  CLASSIFICATIONS = {
    far_west: {
      notched: "Archaic Side Notch",
      stemmed: "Archaic Stemmed",
      lanceolate: "Agate Basin",
      bifurcated: "Cody",
    },
    northern_plains: {
      notched: "Besant",
      stemmed: "Archaic Stemmed",
      lanceolate: "Humboldt Constricted Base",
      bifurcated: "Oxbow",
    },
  }

  # FIXME: I don't have time to deal with this.
  def self.classify(region, shape)
    puts "You have a(n) '#{arrowhead_shape(region, shape)}' arrowhead. Probably priceless."
  end

  private

  def self.arrowhead_shape(region, shape)
    region_shapes = shapes_from(region)
    unless region_shapes.include? shape
      raise "Unknown shape value. Are you sure you know what you're talking about?"
    end
    region_shapes[shape]
  end

  def self.shapes_from(region)
    unless CLASSIFICATIONS.include? region
      raise "Unknown region, please provide a valid region."
    end
    CLASSIFICATIONS[region]
  end
end



puts Arrowhead::classify(:northern_plains, :bifurcated)
