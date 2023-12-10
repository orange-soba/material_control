module ValidCheck
  def valid_check(instance, error_message, check = false)
    instance.valid?
    if check
      return expect(instance.errors.full_messages).to include(error_message)
    else
      binding.pry
    end
  end
end