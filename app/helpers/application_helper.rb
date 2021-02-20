module ApplicationHelper
  def flash_messages
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end

    flash_messages.join("\n").html_safe
  end

  def error_messages(messages)
     flash_messages = messages.map do |message|
      "<script>toastr.error('#{escape_javascript message}');</script>"
    end
    flash_messages.join("\n").html_safe
  end

  def strike_spare_total_format(total, first_shot)
    score = ''
    if total.to_i == 0 && (first_shot.to_i > 0 || first_shot == 'x')
      score = "-"
    else
      score = total
    end
    score
  end
end
