class AddSiteColourToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :pages, :site_colour, :string
  end
end
