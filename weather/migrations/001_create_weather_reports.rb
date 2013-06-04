class CreateWeatherReports <  ActiveRecord::Migration
  def change
    create_table :weather_reports do |t|
      t.text :forecaster_discussion
      t.string :site_code
    end
  end
end
