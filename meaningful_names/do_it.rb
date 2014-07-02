class PrimeFactorization
  attr_accessor :factors, :max_index

  def initialize(max_index = 1_000)
    factors = {}
    @max_index = max_index
    set_factors
  end

  def set_factors
    1.upto(max_index) do |index|
      factors[index] = get_prime_factorization_for(index)
    end
  end

  def get_prime_factorization_for(number)
    dividee = number
    factors = []
    (2..number).each do |n|
      # add factors
      while divides?(dividee, n)
        factors << n
        dividee /= n
      end
    end
    factors
  end

  def get_values(index)
    raise RangeError, 'Value too high!' unless index <= max_index
    factors[index]
  end

  def all
    factors
  end

  private

  def divides?(number, divisor)
    number % divisor == 0
  end
end


u = PrimeFactorization.new(100)
puts u.all
