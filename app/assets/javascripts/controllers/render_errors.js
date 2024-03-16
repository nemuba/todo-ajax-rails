
/**
 * Represents a class for rendering errors.
 * @class
 */
class RenderErrors {
  constructor(args) {
    this.form = args.form;
    this.errorContainer = args.errorContainer;
    this.fields = args.fields;
    this.errors = args.errors;
    this.renderHTML = args.render;
    this.init();
  }

  /**
   * Initializes the errors.
   * @public
   */
  init() {
    const normalizeErrors = this.errors.replace(/&quot;/g, '"');
    this.list = JSON.parse(normalizeErrors);
  }

  /**
   * Renders the errors on the error container.
   * @public
   */
  render() {
    $(this.errorContainer).html(this.renderHTML);

    this.#formFocus();
  }

  /**
   * Sets focus on the first field with an error and adds error classes to the corresponding fields.
   * @private
   */
  #formFocus() {
    // Add focus to the first field with an error
    this.#focusFieldError();

    // Remove class of error from all list
    this.#removeInvalidClass();

    // Add class of error to list with errors
    this.#addInvalidClass();
  }

  /**
   * Sets focus on the first field with an error.
   * @private
   */
  #focusFieldError() {
    $(`${this.form} #todo_${this.list.at(0)}`).focus();
  }

  /**
   * Removes the class of error from all fields.
   * @private
   */
  #removeInvalidClass() {
    this.fields.forEach((field) => {
      $(`${this.form} #todo_${field}`).removeClass('is-invalid');
    });
  }

  /**
   * Adds the class of error to
   * @private
   */
  #addInvalidClass() {
    this.list.forEach((field) => {
      $(`${this.form} #todo_${field}`).addClass('is-invalid');
    });
  }
}

