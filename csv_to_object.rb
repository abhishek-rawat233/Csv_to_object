class WrongNamingConventionError < StandardError
end

require 'csv'
class CsvConverter
  CLASS_NAME = /[[:word:]]+(?=.csv)/
  CLASS_VALID = /[A-Z][[:alnum:]]*$/
  METHOD_VALID = /[a-z][[:alnum:]]*$/

  attr_reader :filerows
  def initialize(filename)
    @filename = filename
    @filerows = []
    getdata
  end

  private

  def getdata
    classname = @filename.match(CLASS_NAME)[0].capitalize
    filedata = reader
    csvheader = filedata.headers
    validation(classname, csvheader)
    class_creator(classname, csvheader)
    datareader(classname, filedata)
  end

  def reader
    CSV.read(@filename, :headers => true)
  end

  def class_creator(name, variable_list)
    klass = Object.const_set(name, Class.new)
    klass_body = "
      attr_reader #{':' + variable_list.join(', :')}
      def initialize(row)
        #{'@' + variable_list.join(', @')} = row
      end
    "
    klass.class_eval(klass_body)
  end

  def validation(classname, method_names = [])
    raise WrongNamingConventionError, 'Please follow correct convention' unless CLASS_VALID =~ classname
    unless method_names.empty?
      method_names.each { |method| raise WrongNamingConventionError, 'Please follow correct convention' unless METHOD_VALID =~ classname }
    end
  end

  def datareader(classname, filedata)
    filedata.each do |row|
      @filerows << object_creation(classname, row.to_s.chomp.split(','))
    end
    @filerows
  end

  def object_creation(class_name, class_data)
    class_obj = "#{class_name}.new(#{class_data})"
    instance_eval(class_obj)
  end
end

if ARGV.empty?
  puts 'please provide an input'
else
  filename = ARGV[0]
  begin
    data_array = CsvConverter.new(filename)
    p data_array
    p data_array.filerows[1]
    p data_array.filerows[0].name
    p data_array.filerows[0].age
    p data_array.filerows[0].city
  rescue => error
    p error
  end
end
