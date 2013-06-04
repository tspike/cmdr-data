class AddDigestToWeatherReports < ActiveRecord::Migration 
  def change
    add_column :weather_reports, :digest, :string, :null => false
    add_index :weather_reports, :digest, :unique => true
  end
end
