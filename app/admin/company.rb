ActiveAdmin.register Company do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

# permit_params :list, :of, :attributes, :on, :model

# or

  permit_params :title, :description, :address, :suburb, :postcode, :state, :phone,
    :abn, :email, :web, :address2, :address3, :country

  index do
    column :title
    column :address
    column :suburb
    column :postcode
    column :state
    column :phone
    column :abn
    column :created_at
    column :updated_at
    column :email
    column :web
    column :address2
    column :address3
    column :country
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :address
      f.input :suburb
      f.input :postcode
      f.input :state
      f.input :phone
      f.input :abn
      f.input :email
      f.input :web
      f.input :address2
      f.input :address3
      f.input :country
      f.actions
    end
  end

end
