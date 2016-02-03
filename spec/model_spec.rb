require "spec_helper"

describe PhModel do
  subject(:model_class) {
    temp_class = Class.new do
      include PhModel

      attribute :foo
    end

    stub_const "FooModel", temp_class

    temp_class
  }

  it { expect(model_class.private_methods).to include :new }
  it { expect(model_class.build(foo: :bar).foo).to eq :bar }

  describe "invalid attribute assignment" do
    example do
      expect {
        model_class.build one: 'two', foo: :bar
      }.to raise_exception(NoMethodError, /undefined method `one=' for #<FooModel foo: nil>/)
    end
  end
end
