ActiveAdmin.register User do

  permit_params :email, :login, :password, :password_confirmation, 
    :company_id, :role

  index do
    id_column
    column :email
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :current_sign_in_ip
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    column :role
    column :company do |user| 
      user.company.title
    end
    column :login
    column :first_name
    column :last_name

    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :email
      f.input :login
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :company_id, :as => :select, :collection => Company.pluck(:title, :id)
      f.input :role, :as => :select, :collection => User.role_options_for_select(current_admin_user.role)
      actions
    end
  end


end
