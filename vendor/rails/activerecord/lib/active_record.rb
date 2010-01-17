#--
# Copyright (c) 2004-2009 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++


activesupport_path = File.expand_path('../../../activesupport/lib', __FILE__)
$:.unshift(activesupport_path) if File.directory?(activesupport_path) && !$:.include?(activesupport_path)

activemodel_path = File.expand_path('../../../activemodel/lib', __FILE__)
$:.unshift(activemodel_path) if File.directory?(activemodel_path) && !$:.include?(activemodel_path)

require 'active_support'
require 'active_model'
require 'arel'

module ActiveRecord
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :VERSION

    autoload :ActiveRecordError, 'active_record/base'
    autoload :ConnectionNotEstablished, 'active_record/base'

    autoload :Aggregations
    autoload :AssociationPreload
    autoload :Associations
    autoload :AttributeMethods
    autoload :Attributes
    autoload :AutosaveAssociation

    autoload :Relation

    autoload_under 'relation' do
      autoload :QueryMethods
      autoload :FinderMethods
      autoload :CalculationMethods
      autoload :PredicateBuilder
      autoload :SpawnMethods
    end

    autoload :Base
    autoload :Batches
    autoload :Calculations
    autoload :Callbacks
    autoload :DynamicFinderMatch
    autoload :DynamicScopeMatch
    autoload :Migration
    autoload :Migrator, 'active_record/migration'
    autoload :NamedScope
    autoload :NestedAttributes
    autoload :Observer
    autoload :QueryCache
    autoload :Reflection
    autoload :Schema
    autoload :SchemaDumper
    autoload :Serialization
    autoload :SessionStore
    autoload :StateMachine
    autoload :Timestamp
    autoload :Transactions
    autoload :Types
    autoload :Validations
  end

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :BeforeTypeCast
      autoload :Dirty
      autoload :PrimaryKey
      autoload :Query
      autoload :Read
      autoload :TimeZoneConversion
      autoload :Write
    end
  end

  module Attributes
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Aliasing
      autoload :Store
      autoload :Typecasting
    end
  end

  module Type
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Number, 'active_record/types/number'
      autoload :Object, 'active_record/types/object'
      autoload :Serialize, 'active_record/types/serialize'
      autoload :TimeWithZone, 'active_record/types/time_with_zone'
      autoload :Unknown, 'active_record/types/unknown'
    end
  end

  module Locking
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Optimistic
      autoload :Pessimistic
    end
  end

  module ConnectionAdapters
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :AbstractAdapter
    end
  end

  autoload :TestCase
  autoload :TestFixtures, 'active_record/fixtures'
end

Arel::Table.engine = Arel::Sql::Engine.new(ActiveRecord::Base)
I18n.load_path << File.dirname(__FILE__) + '/active_record/locale/en.yml'
