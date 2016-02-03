require "spec_helper"

describe ActiveModel::Validations::CollectionItemsValidator::InnerValidatorBuilder do
  subject(:builder) { described_class.new validator_name, options }

  describe "builds an inclusion validator" do
    let(:validator_name) { :inclusion }
    let(:options) { { in: 1..3 } }

    it { expect(builder.build).to be_a ActiveModel::Validations::InclusionValidator }

    context "when the options is in a form of a hash" do
      let(:options) { { in: 1..3 } }

      example do
        expect(ActiveModel::Validations::InclusionValidator).to receive(:new).with(in: 1..3, attributes: [:base])

        builder.build
      end
    end

    context "when the options is in a form of a range" do
      let(:options) { 1..3 }

      example do
        expect(ActiveModel::Validations::InclusionValidator).to receive(:new).with(in: 1..3, attributes: [:base])

        builder.build
      end
    end

    context "when the options is in a form of an array" do
      let(:options) { [1, 2, 3] }

      example do
        expect(ActiveModel::Validations::InclusionValidator).to receive(:new).with(in: [1, 2, 3], attributes: [:base])

        builder.build
      end
    end
  end

  describe "builds a type validator" do
    let(:validator_name) { :type }
    let(:options) { Symbol }

    it { expect(builder.build).to be_a ActiveModel::Validations::TypeValidator }

    example do
      expect(ActiveModel::Validations::TypeValidator).to receive(:new).with(with: Symbol, attributes: [:base])

      builder.build
    end
  end

  describe "builds a presence validator" do
    let(:validator_name) { :presence }
    let(:options) { true }

    it { expect(builder.build).to be_a ActiveModel::Validations::PresenceValidator }

    example do
      expect(ActiveModel::Validations::PresenceValidator).to receive(:new).with(attributes: [:base])

      builder.build
    end
  end
end
