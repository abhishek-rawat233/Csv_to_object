class WrongClassNameError < StandardError
  def message
    'Class name is already in use, please provide new name'
  end
end

class MethodNameError < StandardError
  def message
    'Please enter a valid method name'
  end
end

require 'csv'
class CsvConverter
  CLASS_NAME = /[[:word:]]+(?=.csv)/
  METHOD_VALID = /[a-z][[:alnum:]]*$/

  attr_reader :file_rows
  def initialize(file_name)
    @file_name = file_name
    @file_rows = []
  end

  def get_data
    class_name = @file_name.match(CLASS_NAME)[0].capitalize
    file_data = reader
    csv_header = file_data.headers
    validation(class_name, csv_header)
    @class_ref = class_creator(class_name)
    data_reader(csv_header, file_data)
  end

  private
  def validation(class_name, method_names = [])
    raise WrongClassNameError if Object.const_defined? class_name
    unless method_names.empty?
      method_names.each { |method| raise WrongNamingConventionError, 'Please follow correct convention' unless METHOD_VALID =~ class_name }
    end
  end

  def reader
    CSV.read(@file_name, :headers => true)
  end

  def class_creator(class_name)
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

  def data_reader(csv_header, file_data)
    @class_ref.setup(csv_header)
    file_data.each do |row|
      obj_ref = @class_ref.new
      csv_header.each do |attribute|
        obj_ref.public_send(attribute + '=', row.to_h[attribute])
      end
      @file_rows << obj_ref
    end
    @file_rows
  end
end

if ARGV.empty?
  puts 'please provide an input'
else
  file_name = ARGV[0]
  begin
    data_array = CsvConverter.new(file_name)
    data_array.get_data
    p data_array
    p data_array.file_rows[1]
    p data_array.file_rows[0].name
    p data_array.file_rows[0].age
    p data_array.file_rows[0].city
  rescue => error
    p error.message
  end
end
