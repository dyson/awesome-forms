module AwesomeForms
  class AwesomeFormBuilder
    alias_method :super_label, :label
    def label(method, text = nil, options = {}, &block)
      unless options
        options = {}
      end

      if options[:class]
        options[:class] += ' control-label'
      else
        options[:class] = 'col-lg-2 control-label'
      end

      option_option = options.delete :option
      option_plain = options.delete :plain
      option_before = options.delete :before
      option_after = options.delete :after

      # Mostly from module ActionView::Helpers::InstanceTag.to_label_tag.
      # When a block is passed the text doesnt go through it's usual lookup code.
      # We still want to provide the text via I18n and keep expected label behaviour.
      content = if text.blank?
        if option_option.present?
          I18n.t("awesome.forms.options.#{method}.#{option_option}", :default => '').presence
        else
          I18n.t("helpers.label.#{@object_name}.#{method}", :default => '').presence
        end
      else
        content = text.to_s
      end

      content ||= if @object and @object.class.respond_to?(:human_attribute_name)
        @object.class.human_attribute_name(method)
      end

      content ||= method.to_s.humanize

      # Sub label text
      unless method.blank?
        sub_label = I18n.t("awesome.forms.labels.#{@object_name}.#{method}", default: '').presence
        unless sub_label.blank?
          content += @template.render partial: 'awesome/forms/sub_label', locals: {sub_label: sub_label.to_s.html_safe}
          content = content
        end
      end

      if option_plain.present?
        return content.to_s.html_safe
      else
        super do
          content = option_before.to_s.html_safe + content.to_s.html_safe + option_after.to_s.html_safe
        end
      end
    end
  end
end
