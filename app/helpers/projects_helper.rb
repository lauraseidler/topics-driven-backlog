module ProjectsHelper
  def validate_users
    errors = []

    if params[:user_ids].present?

      params[:user_ids] = filter_unique_parameter_list(params[:user_ids])

      params[:user_ids].each do |user_id|
        errors.append(
            valid_user_id(user_id)
        )
      end

      raise_exception_on_validation_error(errors)
    end

  end

  private

  def filter_unique_parameter_list(list)
    list.uniq
  end

  def valid_user_id(user_id)
    if User.find_by(id: user_id).nil?
      'User ' + user_id.to_s + ' does not exist'
    end
  end
end
