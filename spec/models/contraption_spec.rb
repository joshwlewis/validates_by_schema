require 'spec_helper'

describe Contraption do
	fixtures :widgets
	subject { Contraption.new widgets(:secret).attributes }

  context 'should validate columns of type:' do

    context :string do
      it { should_not validate_presence_of(:name)}
      it { should ensure_length_of(:name).is_at_most(50) }
      it { should validate_presence_of(:model) }
      it { should ensure_length_of(:model).is_at_most(255)}
    end

    context :text do 
      it { should_not validate_presence_of(:description)}
      it { should_not ensure_length_of(:description).is_at_most(10000000)}
    end

    context :integer do
      it { should validate_presence_of(:wheels)}
      it { should validate_numericality_of(:wheels).only_integer }
      it { should allow_value(242424).for(:wheels)}
      it { should allow_value(-42424).for(:wheels)}
      if ENV['DB'] == 'mysql'
        it { should_not allow_value(10**100).for(:wheels)}
        it { should_not allow_value(-10**100).for(:wheels)}
      end


      it { should_not validate_presence_of(:doors)}
      it { should validate_numericality_of(:doors).only_integer }
      it { should allow_value(250).for(:doors)}
      it { should allow_value(-500).for(:doors)}
      it { should_not allow_value(10**100).for(:doors)}
      it { should_not allow_value(-10**100).for(:doors)}
    end

    context :decimal do
      it { should_not validate_presence_of(:price)}
      it { should validate_numericality_of(:price)}
      it { should allow_value(-1205).for(:price)}
      it { should allow_value(4242.42).for(:price)}
      it { should_not allow_value(24242).for(:price)}
      it { should_not allow_value(-42424.24).for(:price)}

      it { should validate_presence_of(:cost)}
      it { should validate_numericality_of(:cost)}
      it { should allow_value(42).for(:cost)}
      it { should allow_value(-24.24).for(:cost)}
      it { should_not allow_value(424).for(:cost)}
      it { should_not allow_value(-242.42).for(:cost)}
    end

    context :float do
      it { should_not validate_presence_of(:rating)}
      it { should validate_numericality_of(:rating)}
      it { should allow_value(242424.242424).for(:rating)}
      it { should allow_value(-5).for(:rating)}

      it { should validate_presence_of(:score)}
      it { should validate_numericality_of(:score)}
      it { should allow_value(242424.242424).for(:score)}
      it { should allow_value(-5).for(:score)}
    end

    context :datetime do
      it { should_not validate_presence_of(:published_at)}
    end

    context :date do 
      it { should_not validate_presence_of(:invented_on)}
    end

    context :time do
      it { should_not validate_presence_of(:startup_time)}
      it { should validate_presence_of(:shutdown_time)}
    end

  end

end