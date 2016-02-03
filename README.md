# ph_model

* [Homepage](https://rubygems.org/gems/ph_model)
* [Documentation](http://rubydoc.info/gems/ph_model/frames)
* [Email](mailto:piotr@payrollhero.com)
# [Changelog](CHANGELOG.md)

## Description

[![Build Status](https://travis-ci.org/payrollhero/ph_model.svg?branch=master)](https://travis-ci.org/payrollhero/ph_model)
[![Code Climate](https://codeclimate.com/github/payrollhero/ph_model/badges/gpa.svg)](https://codeclimate.com/github/payrollhero/ph_model)
[![Issue Count](https://codeclimate.com/github/payrollhero/ph_model/badges/issue_count.svg)](https://codeclimate.com/github/payrollhero/ph_model)
[![Dependency Status](https://gemnasium.com/payrollhero/ph_model.svg)](https://gemnasium.com/payrollhero/ph_model)

This Gem basically marries ActiveModel and ActiveAttr is a nice package.

The general format for this is that you make classes mixing in PhModel, and then you can use them easier
as data objects.

Eg:
```ruby
class MyModel
  include PhModel
  
  attribute :name, type: String
  attribute :age, type: Fixnum
  
  validates :name, presence: true
  validates :age, presence: true
end
```

And then .. you're meant to build these things via `.build` to ensure that they're valid when constructed.

Eg:
```ruby
model = MyModel.build(name: "John", age: 21)
```

And if you were to try to construct it invalid, you'd get:

```ruby
model = MyModel.build(name: "John")
# Raises: PhModel::ValidationFailed: MyModel is invalid: Age can't be blank
```

## Copyright

Copyright (c) 2015 PayrollHero
