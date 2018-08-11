ActiveAdmin.register Group do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :chat_id, :name, :admin_user_id

form do |f|
    f.inputs do
      f.input :name
      f.input :chat_id
      f.input :admin_user_id, :input_html => { :value => current_admin_user[:id]}, as: :hidden

    end
    f.actions
  end
end
