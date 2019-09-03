class PredefinedConstantError < StandardError
  def initialize(message = nil)
    @message = message
  end

  def to_s
    @message || 'Class name is already in use, please provide new name'
  end
end

class MethodNameError < StandardError
  def initialize(message = nil)
    @message = message
  end
  def to_s
    @message || 'Please enter a valid method name'
  end
end

require 'csv'
class CsvConverter
  FILE_NAME_EXTRACTOR = /[[:word:]]+(?=.csv)/
  METHOD_NAME_VALIDATOR = /[a-z][[:alnum:]]*$/

  attr_reader :file_rows
  def initialize(file_name)
    @file_name = file_name
    @file_rows = []
  end

  def save_objects
    class_name = @file_name.match(FILE_NAME_EXTRACTOR)[0].capitalize
    file_data = csv_reader
    csv_header = file_data.headers
    validation(class_name, csv_header)
    @class_ref = class_creator(class_name)
    data_reader(csv_header, file_data)
  end

  private
  def validation(class_name, method_names = [])
    raise PredefinedConstantError if Object.const_defined? class_name
    unless method_names.empty?
      method_names.each { |method| raise WrongNamingConventionError.new("Please follow correct convention for #{method}") unless METHOD_NAME_VALIDATOR =~ method }
    end
  end

  def csv_reader
    CSV.read(@file_name, headers: true)
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
    data_array.save_objects
    p data_array
    p data_array.file_rows[1]
    p data_array.file_rows[0].name
    p data_array.file_rows[0].age
    p data_array.file_rows[0].city
  rescue => error
    p error.message
  end
end
