require 'spec_helper'

describe Contraption do
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should validate_presence_of(:model) }
  it { should ensure_length_of(:model).is_at_most(255)}
  it { should validate_presence_of(:wheels)}
  it { should validate_numericality_of(:wheels).only_integer }
  it { should validate_numericality_of(:doors).only_integer }

end