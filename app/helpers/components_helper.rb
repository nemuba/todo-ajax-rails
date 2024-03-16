# frozen_string_literal: true

# The ComponentsHelper module provides helper methods for generating links with various options.
module ComponentsHelper
  # Generates a link with the given URL and options.
  #
  # @param url [String] The URL for the link.
  # @param opts [Hash] The options for the link.
  # @option opts [String] :class_name The CSS class for the link.
  # @option opts [Boolean] :remote Whether the link should be remote or not.
  # @option opts [String] :title The title for the link.
  # @option opts [String] :icon The icon for the link.
  # @return [String] The generated link.
  def link(url, opts = {})
    link_to url, class: opts[:class_name] || 'btn btn-sm btn-primary', remote: opts[:remote] || true,
                 data: { bs_toggle: 'tooltip', bs_title: opts[:title] } do
      opts[:icon] ? fa_icon(opts[:icon]) : opts[:title]
    end
  end

  # Generates a new link with the given URL.
  #
  # @param url [String] The URL for the link.
  # @return [String] The generated new link.
  def link_new(url)
    link(url,
         { title: translate_link('new', model: translate_model(Todo)), class_name: 'btn btn-sm btn-primary' })
  end

  # Generates a show link with the given URL.
  #
  # @param url [String] The URL for the link.
  # @return [String] The generated show link.
  def link_show(url)
    link(url, { icon: 'eye', title: translate_link('show'), class_name: 'btn btn-sm btn-info' })
  end

  # Generates an edit link with the given URL.
  #
  # @param url [String] The URL for the link.
  # @return [String] The generated edit link.
  def link_edit(url)
    link(url, { icon: 'edit', title: translate_link('edit'), class_name: 'btn btn-sm btn-success' })
  end

  # Generates a confirm delete link with the given URL.
  #
  # @param url [String] The URL for the link.
  # @return [String] The generated confirm delete link.
  def link_confirm_delete(url)
    link(url,
         { icon: 'trash', title: translate_link('confirm_delete'), class_name: 'btn btn-sm btn-danger',
           remote: true })
  end

  def close_modal_button(title)
    button_tag title, type: 'button', class: 'btn btn-danger', data: { bs_dismiss: 'modal' }
  end

  def submit_button(form, delete: false)
    title = case delete
            when true
              :delete
            else
              form.object.new_record? ? :new : :edit
            end

    form.submit translate_btn(form.object.class, title), class: 'btn btn-primary'
  end
end
