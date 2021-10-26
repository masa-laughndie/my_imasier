class Duration
  def self.build(as_duration)
    new(as_duration.parts.values[0], as_duration.parts.keys[0])
  end

  def initialize(number, unit)
    @_duration = number.send(unit.to_sym)
  end

  def number
    _duration.parts.values[0]
  end

  def unit
    _duration.parts.keys[0]
  end

  def /(other)
    define_method_for_duration_and_as_duration(:/, other)
  end

  def >(other)
    define_method_for_duration_and_as_duration(:>, other)
  end

  def >=(other)
    define_method_for_duration_and_as_duration(:>=, other)
  end

  def <(other)
    define_method_for_duration_and_as_duration(:<, other)
  end

  def <=(other)
    define_method_for_duration_and_as_duration(:<=, other)
  end

  protected

  attr_reader :_duration

  private

  def define_method_for_duration_and_as_duration(method_name, other)
    if Duration === other
      _duration.__send__(method_name.to_sym, other._duration)
    elsif ActiveSupport::Duration === other
      _duration.__send__(method_name.to_sym, other)
    else
      raise TypeError, "no implicit conversion of #{other.class} into #{self.class}"
    end
  end
end
