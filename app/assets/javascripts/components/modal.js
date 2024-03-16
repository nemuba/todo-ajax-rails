
/**
 * Represents a modal dialog.
 * @class
 */
class Modal {
  constructor(modal, title, body) {
    this.modal = new bootstrap.Modal($(modal));
    this.title = title;
    this.body = body;
    this.init();
  }

  /**
   * Initializes the modal dialog events.
   * @public
   */
  init() {
    this.modal._element.addEventListener('hidden.bs.modal', () => {
      this.close();
    });
  }

  /**
   * Displays the modal dialog with the specified title and form.
   * @param {string} title - The title of the modal dialog.
   * @param {string} form - The HTML form to be displayed in the modal dialog.
   */
  show(title, form) {
    $(this.title).html(title);
    $(this.body).html(form);
    this.modal.show();
  }

  /**
   * Closes the modal dialog and clears the title and body content.
   */
  close() {
    $(this.title).html('');
    $(this.body).html('');
  }
}

