require "spec_helper"

describe ActiveModel::Validations::CollectionItemsValidator::ArrayAttributeGetter do
  subject(:getter) do
    described_class.new attribute,
                        when_array: when_array_proc,
                        when_normal: when_normal_proc
  end

  let(:when_array_proc) { -> (_attribute, _index) { :noop } }
  let(:when_normal_proc) { -> { :noop } }

  describe "#get" do
    context "when the attribute is an array" do
      let(:attribute) { :"foo[0]" }

      it do
        expect(when_array_proc).to receive(:call).with(:foo, 0)

        getter.get
      end
    end

    context "when the attribute is an array" do
      let(:attribute) { :foo }

      it do
        expect(when_normal_proc).to receive(:call).with(no_args)

        getter.get
      end
    end
  end
end
