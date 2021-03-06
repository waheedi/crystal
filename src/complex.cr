# A complex number is a number represented in the form a + bi. In this form,
# a and b are real numbers, and i is an imaginary number such as i² = -1.
# The a is the real part of the number, and the b is the imaginary part of
# the number.
#
# ```
# require "complex"
#
# Complex.new(1, 0)   # => 1.0 + 0.0i
# Complex.new(5, -12) # => 5.0 - 12.0i
#
# 1.to_c # => 1.0 + 0.0i
# 1.i    # => 0.0 + 1.0i
# ```
struct Complex
  # Returns the real part.
  getter real : Float64

  # Returns the imaginary part.
  getter imag : Float64

  def initialize(real : Number, imag : Number)
    @real = real.to_f
    @imag = imag.to_f
  end

  # Determines whether `self` equals *other* or not.
  def ==(other : Complex)
    @real == other.real && @imag == other.imag
  end

  # ditto
  def ==(other : Number)
    self == other.to_c
  end

  # ditto
  def ==(other)
    false
  end

  # Returns `self`.
  def to_c
    self
  end

  # Returns the value as a `Float64` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_f64
    unless @imag.zero?
      raise Exception.new "Complex number with non-zero imaginary part can't be converted to real number"
    end
    @real
  end

  # Returns the value as a `Float32` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_f32
    to_f64.to_f32
  end

  # See `#to_f64`.
  def to_f
    to_f64
  end

  # Returns the value as an `Int64` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_i64
    to_f64.to_i64
  end

  # Returns the value as a `Int32` if possible (the imaginary part should be exactly zero),
  # raises otherwise.
  def to_i32
    to_i64.to_i32
  end

  # See `#to_i32`.
  def to_i
    to_i32
  end

  # Writes this complex object to an *io*.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).to_s # => "42.0 + 2.0i"
  # ```
  def to_s(io : IO) : Nil
    io << @real
    io << (@imag >= 0 ? " + " : " - ")
    io << @imag.abs
    io << 'i'
  end

  # Writes this complex object to an *io*, surrounded by parentheses.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).inspect # => "(42.0 + 2.0i)"
  # ```
  def inspect(io : IO) : Nil
    io << '('
    to_s(io)
    io << ')'
  end

  # Returns the absolute value of this complex number in a
  # number form, using the Pythagorean theorem.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).abs  # => 42.04759208325728
  # Complex.new(-42, 2).abs # => 42.04759208325728
  # ```
  def abs
    Math.hypot(@real, @imag)
  end

  # Returns the square of absolute value in a number form.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).abs2 # => 1768
  # ```
  def abs2
    @real * @real + @imag * @imag
  end

  def sign
    self / abs
  end

  # Returns the phase of `self`.
  def phase
    Math.atan2(@imag, @real)
  end

  # Returns a `Tuple` with the `abs` value and the `phase`.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).polar # => {42.047592083257278, 0.047583103276983396}
  # ```
  def polar
    {abs, phase}
  end

  # Returns the conjugate of `self`.
  #
  # ```
  # require "complex"
  #
  # Complex.new(42, 2).conj  # => 42.0 - 2.0i
  # Complex.new(42, -2).conj # => 42.0 + 2.0i
  # ```
  def conj
    Complex.new(@real, -@imag)
  end

  # Returns the inverse of `self`.
  def inv
    conj / abs2
  end

  # `Complex#sqrt` was inspired by the [following blog post](https://pavpanchekha.com/casio/)
  # of Pavel Panchekha on floating point precision.
  #
  def sqrt
    r = abs

    re = if @real >= 0
           0.5 * Math.sqrt(2.0 * (r + @real))
         else
           @imag.abs / Math.sqrt(2 * (r - @real))
         end

    im = if @real <= 0
           0.5 * Math.sqrt(2.0 * (r - @real))
         else
           @imag.abs / Math.sqrt(2 * (r + @real))
         end

    Complex.new(re, @imag >= 0 ? im : -im)
  end

  # Calculates the exp of `self`.
  #
  # ```
  # require "complex"
  #
  # Complex.new(4, 2).exp # => -22.720847417619233 + 49.645957334580565i
  # ```
  def exp
    r = Math.exp(@real)
    Complex.new(r * Math.cos(@imag), r * Math.sin(@imag))
  end

  # Calculates the log of `self`.
  def log
    Complex.new(Math.log(abs), phase)
  end

  # Calculates the log2 of `self`.
  def log2
    log / Math::LOG2
  end

  # Calculates the log10 of `self`.
  def log10
    log / Math::LOG10
  end

  # Returns absolute value of `self`.
  def +
    Complex.new(@real.abs, @imag.abs)
  end

  # Adds the value of `self` to *other*.
  def +(other : Complex)
    Complex.new(@real + other.real, @imag + other.imag)
  end

  # ditto
  def +(other : Number)
    Complex.new(@real + other, @imag)
  end

  # Returns the opposite of `self`.
  def -
    Complex.new(-@real, -@imag)
  end

  # Removes the value of *other* from `self`.
  def -(other : Complex)
    Complex.new(@real - other.real, @imag - other.imag)
  end

  # ditto
  def -(other : Number)
    Complex.new(@real - other, @imag)
  end

  # Multiplies `self` by *other*.
  def *(other : Complex)
    Complex.new(@real * other.real - @imag * other.imag, @real * other.imag + @imag * other.real)
  end

  # ditto
  def *(other : Number)
    Complex.new(@real * other, @imag * other)
  end

  # Divides `self` by *other*.
  def /(other : Complex)
    if other.real <= other.imag
      r = other.real / other.imag
      d = other.imag + r * other.real
      Complex.new((@real * r + @imag) / d, (@imag * r - @real) / d)
    else
      r = other.imag / other.real
      d = other.real + r * other.imag
      Complex.new((@real + @imag * r) / d, (@imag - @real * r) / d)
    end
  end

  # ditto
  def /(other : Number)
    Complex.new(@real / other, @imag / other)
  end

  def clone
    self
  end

  # See `Object#hash(hasher)`
  def hash(hasher)
    hasher = real.hash(hasher)
    hasher = imag.hash(hasher) unless imag.zero?
    hasher
  end

  # Returns the number `0` in complex form.
  def self.zero : Complex
    new 0, 0
  end

  def zero? : Bool
    @real == 0 && @imag == 0
  end
end

struct Number
  def to_c
    Complex.new(self, 0)
  end

  def i
    Complex.new(0, self)
  end

  def ==(other : Complex)
    to_c == other
  end

  def cis
    Complex.new(Math.cos(self), Math.sin(self))
  end

  def +(other : Complex)
    Complex.new(self + other.real, other.imag)
  end

  def -(other : Complex)
    Complex.new(self - other.real, -other.imag)
  end

  def *(other : Complex)
    Complex.new(self * other.real, self * other.imag)
  end

  def /(other : Complex)
    self * other.inv
  end
end
