class ValidatesBySchema::ValidationOption
  # column here must be an ActiveRecord column
  # i.e. MyARModel.columns.first
  attr_accessor :klass, :column

  def initialize(klass, column)
    @klass = klass
    @column = column
  end

  def define!
    if association
      # Only presence and uniqueness are handled for associations.
      # presence on the association name, uniqueness on the column name.
      define_belongs_to_presence_validation
    else
      define_validations(to_hash)
    end
    define_uniqueness_validations if ValidatesBySchema.validate_uniqueness
  end

  private

  def define_belongs_to_presence_validation
    klass.validates association.name, presence: true if !ActiveRecord::Base.belongs_to_required_by_default && presence
  end

  def define_uniqueness_validations
    uniqueness.each do |options|
      define_validations(uniqueness: options)
    end
  end

  def define_validations(options)
    klass.validates column.name, options if options.present?
  end

  def presence?
    presence && column.type != :boolean && column.default.nil?
  end

  def presence
    !column.null
  end

  def enum?
    klass.respond_to?(:defined_enums) && klass.defined_enums.has_key?(column.name)
  end

  def numericality?
    [:integer, :decimal, :float].include?(column.type) && !enum?
  end

  def numericality
    numericality = {}
    if column.type == :integer
      numericality[:only_integer] = true
      if integer_max
        numericality[:less_than] = integer_max
        numericality[:greater_than] = -integer_max
      end
    elsif column.type == :decimal && decimal_max
      numericality[:less_than_or_equal_to] = decimal_max
      numericality[:greater_than_or_equal_to] = -decimal_max
    end
    numericality[:allow_nil] = true
    numericality
  end

  def uniqueness
    unique_indexes.map do |index|
      {
        scope: index.columns.reject { |col| col == column.name },
        conditions: -> { where(index.where) },
        allow_nil: column.null,
        case_sensitive: case_sensitive?,
        if: ->(model) { index.columns.any? { |c| model.send("#{c}_changed?") } }
      }
    end
  end

  def unique_indexes
    klass
      .connection
      .indexes(klass.table_name)
      .select { |index| index.unique && index.columns.first == column.name }
  end

  def case_sensitive?
    !klass.connection.respond_to?(:collation) ||
      !klass.connection.collation.end_with?('_ci')
  end

  def array?
    column.respond_to?(:array) && column.array
  end

  def length?
    [:string, :text].include?(column.type) && column.limit && !array?
  end

  def length
    { maximum: column.limit, allow_nil: true }
  end

  def inclusion?
    column.type == :boolean
  end

  def inclusion
    { in: [true, false], allow_nil: column.null }
  end

  def integer_max
    (2**(8 * column.limit)) / 2 if column.limit
  end

  def decimal_max
    10.0**(column.precision - column.scale) - 10.0**(-column.scale) if column.precision && column.scale
  end

  def association
    @association ||= klass.reflect_on_all_associations(:belongs_to).find do |a|
      a.foreign_key.to_s == column.name
    end
  end

  def to_hash
    [:presence, :numericality, :length, :inclusion].inject({}) do |h, k|
      send(:"#{k}?") ? h.merge(k => send(k)) : h
    end
  end

  def to_s
    to_hash.inspect
  end

end
