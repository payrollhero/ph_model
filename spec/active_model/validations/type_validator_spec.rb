require "spec_helper"

describe ActiveModel::Validations::TypeValidator do
  subject(:model_class) {
    temp_class = Class.new do
      include PhModel

      attribute :foo

      validates :foo, type: [Symbol, String]
    end

    stub_const "FooModel", temp_class

    temp_class
  }

  it {
    expect {
      model_class.build foo: 1
    }.to raise_error PhModel::ValidationFailed, "FooModel is invalid: Foo must be a Symbol or String"
  }

  it { expect { model_class.build foo: :bar }.to_not raise_error }
end
