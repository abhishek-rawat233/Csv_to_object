require 'csv'
class CsvConverter
  CLASS_NAME = /[[:word:]]+(?=.csv)/

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
    class_creator(classname, filedata.headers)
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
  data_array = CsvConverter.new(filename)
  p data_array
  p data_array.filerows[1]
  p data_array.filerows[0].city
  p data_array.filerows[0].name
  p data_array.filerows[0].age
  p data_array.filerows[0].city
end
