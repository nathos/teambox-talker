module AccountsHelper
  def meter_tag(rate)
    rate = 1.0 if rate > 1.0
    content_tag(:div,
      content_tag(:span, "&nbsp;", :style => "width: #{number_to_percentage rate * 100.0}",
                                   :class => "#{'reached' if rate == 1.0}"),
      :class => "meter")
  end
  
  def feature_line(title, description=nil, &block)
    content_tag(:tr,
      content_tag(:th, title +
                       content_tag(:div, description, :class => "description")) +
      Plan.new_plans.map { |plan|
        content_tag(:td, block.call(plan.features), :class => ("current" if current_account.plan == plan))
      }.join
    )
  end
end
