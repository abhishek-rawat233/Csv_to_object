require_relative '../lib/csv_converter.rb'
file_name = 'person.csv'
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
