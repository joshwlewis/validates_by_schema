class ValidatesBySchema::ValidationOption
  # column here must be an ActiveRecord column
  # i.e. MyARModel.columns.first
  attr_accessor :column

  def initialize(column)
    @column = column
  end

  def presence?
    presence && column.type != :boolean
  end

  def presence
    !column.null
  end

  def numericality?
    [:integer, :decimal, :float].include? column.type
  end

  def numericality
    numericality = {}
    if column.type == :integer
      numericality[:only_integer] = true
      if integer_max
        numericality[:less_than] = integer_max
        numericality[:greater_than] = -integer_max
      end
    elsif column.type == :decimal
      numericality[:less_than_or_equal_to] = decimal_max
      numericality[:greater_than_or_equal_to] = -decimal_max
    end
    numericality[:allow_nil] = column.null
    numericality
  end

  def length?
    [:string, :text].include?(column.type) && column.limit
  end

  def length
    {:maximum => column.limit, :allow_nil => column.null }
  end

  def inclusion?
    column.type == :boolean
  end

  def inclusion
    {:in => [true, false], :allow_nil => column.null}
  end

  def integer_max
    (2 ** (8 * column.limit)) / 2 if column.limit
  end

  def decimal_max
    10.0**(column.precision-column.scale) - 10.0**(-column.scale)
  end

  def string_max
    column.limit
  end

  def to_hash
    [:presence, :numericality, :length, :inclusion].inject({}) do |h,k|
      send(:"#{k}?") ? h.merge(k => send(k)) : h
    end
  end

  def to_s
    to_hash.inspect
  end

end