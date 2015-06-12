json.chart_data do
  json.array! @range_percentage_data do |data|
    json.key data[:label]
    json.values data[:data] do |date, value|
       json.x (@date.to_datetime + (date.to_i+3).hours).to_i*1000
       json.y value.round
    end 
  end
end