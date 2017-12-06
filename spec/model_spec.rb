require "spec_helper"

describe PhModel do
  subject(:model_class) do
    Class.new do
      include PhModel
      attribute :foo
    end
  end

  let(:klass) do
    subject.tap do |temp_class|
      stub_const "FooModel", temp_class
    end
  end

  it { expect(klass.private_methods).to include :new }
  it { expect(klass.build(foo: :bar).foo).to eq :bar }

  describe "invalid attribute assignment" do
    example do
      expect {
        klass.build one: 'two', foo: :bar
      }.to raise_exception(NoMethodError, /undefined method `one=' for #<FooModel foo: nil>/)
    end
  end

  describe "AttributeRequiredValidation" do
    subject(:model_class) do
      Class.new do
        include PhModel
        attribute :foo, required: true
      end
    end

    example do
      expect {
        klass.build
      }.to raise_exception(PhModel::ValidationFailed, "FooModel is invalid: Foo can't be empty")
    end
  end

  describe "AttributeTypeValidation" do
    describe "simple type" do
      subject(:model_class) do
        Class.new do
          include PhModel
          attribute :foo, type: String
        end
      end

      example do
        expect {
          klass.build foo: 1
        }.to raise_exception(PhModel::ValidationFailed, /FooModel is invalid: Foo must be String, was (Fixnum|Integer)/)
      end
    end

    describe "array type" do
      subject(:model_class) do
        Class.new do
          include PhModel
          attribute :foo, type: [String]
        end
      end

      example do
        expect {
          klass.build foo: "Hello"
        }.to raise_exception(PhModel::ValidationFailed, "FooModel is invalid: Foo must be [String], was String")
      end
    end
  end
end
