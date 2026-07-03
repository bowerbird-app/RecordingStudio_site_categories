class AddSitePublicationsToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :pages, :site_publications, :text, array: true, default: []
  end
end
