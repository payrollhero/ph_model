require "spec_helper"

describe PhModel do
  subject(:model_class) {
    temp_class = Class.new do
      include PhModel

      attribute :foo

      validates :foo, collection_items: { type: Symbol, inclusion: { in: [:foo, :bar] } }
    end

    stub_const "FooModel", temp_class

    temp_class
  }

  it {
    expect {
      model_class.build foo: :bar
    }.to raise_error PhModel::ValidationFailed, "FooModel is invalid: Foo must be a collection"
  }

  it {
    expect {
      model_class.build foo: [:foo, "bar", :not]
    }.to raise_error PhModel::ValidationFailed, "FooModel is invalid: Foo[1] must be a Symbol\n"\
                                                           "Foo[1] is not included in the list\n"\
                                                           "Foo[2] is not included in the list"
  }

  it { expect { model_class.build foo: [:bar] }.to_not raise_error }
end
