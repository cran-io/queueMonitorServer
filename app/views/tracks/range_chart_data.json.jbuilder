json.chart_data do
  json.array! @range_percentage_data do |data|
    json.area data[:area]
    json.key data[:label]
    json.values data[:data] do |date, value|
       json.x date.to_datetime.to_i*1000
       json.y value
    end 
  end
end