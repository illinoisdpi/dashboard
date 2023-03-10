class AddCsvFilenameToPiazzaActivityDownloads < ActiveRecord::Migration[7.0]
  def change
    add_column :piazza_activity_downloads, :csv_filename, :string
  end
end
