require 'csv'
require_relative 'predefined_constant_error.rb'
require_relative 'wrong_naming_convention_error.rb'

class CsvConverter
  FILE_NAME_EXTRACTOR = /[[:word:]]+(?=.csv)/
  METHOD_NAME_VALIDATOR = /[a-z][[:alnum:]]*$/
  CLASS_NAME_VALIDATOR = /[A-Z][[:alnum:]]*$/

  attr_reader :file_rows
  def initialize(file_name)
    @file_name = file_name
    @file_rows = []
  end

  def save_objects
    class_name = @file_name.match(FILE_NAME_EXTRACTOR)[0].capitalize
    file_data = read_file
    header = file_data.headers
    execute_validations(class_name, header)
    @class_ref = class_factory(class_name)
    object_recorder(header, file_data)
  end

  private
  def execute_validations(name, method_list)
    class_name_validator(name)
    method_name_validator(method_list)
  end

  def class_name_validator(name)
    raise PredefinedConstantError if Object.const_defined? name
    raise WrongNamingConventionError, "Please change the file name" unless CLASS_NAME_VALIDATOR =~ name
  end

  def method_name_validator(method_names = [])
    method_names.each { |method| raise WrongNamingConventionError, "Please follow correct convention for #{method}" unless METHOD_NAME_VALIDATOR =~ method }
  end

  def read_file
    CSV.read(@file_name, headers: true)
  end

  def class_factory(class_name)
    klass = Class.new do
      def self.setup(attribute_list)
        @attributes = attribute_list
        class_eval do
          attributes.each { |attr| attr_accessor attr.to_sym }
        end
      end

      def self.attributes
        @attributes
      end
    end
    Object.const_set(class_name, klass)
  end

  def object_recorder(header, file_data)
    @class_ref.setup(header)
    file_data.each do |row|
      obj_ref = @class_ref.new
      header.each do |attribute|
        obj_ref.public_send(attribute + '=', row.to_h[attribute])
      end
      @file_rows << obj_ref
    end
    @file_rows
  end
end
