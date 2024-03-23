// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const MODAL = '#todo-modal';
const MODAL_TITLE = `${MODAL} .modal-title`;
const MODAL_BODY = `${MODAL} #modal-body`;
const MODAL_ERRORS = `${MODAL} #form-errors`;
const MODAL_FORM = `${MODAL} #todo`;
const TODO_TARGET = '#todos';
const EMPTY_ROWS = '#empty_rows';
const TODO_TOTAL = '#todos-total';
/**
 * Represents a Todo.
 * @class
 */
class Todo extends Base {
  /**
   * The fields of the Todo.
   * @static
   * @type {Array}
   */
  static fields = ['title', 'description', 'status'];

  /**
   * The arguments for the Todo.
   * @static
   * @type {Object}
   * @property {string} form - The form for the Todo.
   * @property {string} errorContainer - The error container for the Todo.
   * @property {Array} fields - The fields for the Todo.
   * @returns {Object} The arguments for the Todo.
   */
  static args = {
    form: MODAL_FORM,
    errorContainer: MODAL_ERRORS,
    fields: this.fields
  }

  /**
   * Appends a new Todo to the list.
   * @static
   * @param {HTMLElement} todo - The new Todo to be appended.
   * @returns {void}
   */
  static append(target = TODO_TARGET, todo) {
    $(target).append(todo).fadeIn();
    $(EMPTY_ROWS).hide();
    this.updateTotal();
  }

  /**
   * Prepends a new Todo to the list.
   * @static
   * @param {HTMLElement} todo - The new Todo to be prepended.
   * @returns {void}
   */
  static prepend(target = TODO_TARGET, todo) {
    $(target).prepend(todo).fadeIn();
    $(EMPTY_ROWS).hide();
    this.updateTotal();
  }

  /**
   * Updates an existing Todo.
   * @static
   * @param {string} id - The id of the Todo.
   * @param {HTMLElement} todo - The updated Todo.
   * @returns {void}
   */
  static update(target = TODO_TARGET, id, todo) {
    $(target).find(`#todo-${id}`).replaceWith(todo).fadeIn();
    $(EMPTY_ROWS).hide();
    this.updateTotal();
  }

  /**
   * Removes an existing Todo.
   * @static
   * @param {string} id - The id of the Todo.
   * @returns {void}
   */
  static remove(target = TODO_TARGET, id) {
    $(target).find(`#todo-${id}`).remove().fadeOut();

    if (this.rows() == 0) {
      $(EMPTY_ROWS).show();
    } else {
      $(EMPTY_ROWS).hide();
    }

    this.updateTotal();
  }

  /**
   * Returns the number of rows in the Todo list.
   * @static
   * @returns {number} The number of rows in the Todo list.
   */
  static rows() {
    return $(TODO_TARGET).find('tr[id^="todo-"]').length;
  }

  /**
   * Updates the total number of records in the Todo list.
   * @static
   * @returns {void}
   */
  static updateTotal() {
    new Tooltip();

    $(TODO_TOTAL).text(`Total de registros: ${this.rows()}`);
  }

  /**
   * Renders the list of Todos.
   * @static
   * @param {HTMLElement} todos - The list of Todos to be rendered.
   * @returns {void}
   */
  static renderTodos(todos) {
    $(TODO_TARGET).html(todos);
    this.updateTotal();
  }

  /**
   * Renders inline the form for the Todo.
   * @static
   * @param {string} id - The id of the Todo.
   * @param {string} field - The field of the Todo.
   * @param {HTMLElement} form - The form to be rendered.
   * @returns {void}
   */
  static renderInline(target = TODO_TARGET, id, field, form) {
    $(`${TODO_TARGET} #todo-${id}`).find(`#todo-${field}-${id}`).html(form);
  }

  /**
   * The modal for the Todo.
   * @static
   * @type {App.Modal}
   * @returns {App.Modal} The modal for the Todo.
   */
  static get Modal() { return new Modal(MODAL, MODAL_TITLE, MODAL_BODY) }

  /**
   * Creates a new Todo.
   * @static
   * @param {string} title - The title of the Todo.
   * @param {HTMLElement} form - The form element for creating the Todo.
   */
  static new(title, form) {
    this.Modal.show(title, form);
  }

  /**
   * Shows the details of a Todo.
   * @static
   * @param {string} title - The title of the Todo.
   * @param {string} body - The body of the Todo.
   */
  static show(title, body) {
    this.Modal.show(title, body);
  }

  /**
   * Edits an existing Todo.
   * @static
   * @param {string} title - The title of the Todo.
   * @param {HTMLElement} form - The form element for editing the Todo.
   */
  static edit(title, form) {
    this.Modal.show(title, form);
  }

  /**
   * Confirms the deletion of a Todo.
   * @static
   * @param {string} title - The title of the Todo.
   * @param {string} body - The body of the Todo.
   */
  static confirmDelete(title, body) {
    this.Modal.show(title, body);
  }

  static toggleMore(id, url) {
    if ($(TODO_TARGET).find(`#more-todo-${id}`).length > 0) {
      $(TODO_TARGET).find(`#more-todo-${id}`).remove();
      $(`#btn-more-todo-${id}`).toggleClass('active');
    } else {
      // request type xhr
      $.get(url)
      $(`#btn-more-todo-${id}`).toggleClass('active');
    }
  }

  /**
   * Renders the errors in the Todo form.
   * @static
   * @param {string} errors - The errors to be rendered.
   */
  static renderErrors(render, errors) {
    const args = this.#mergeObjects({ render, errors });
    new RenderErrors(args).render();
  }

  /**
   * Merges the arguments for the Todo.
   * @static
   * @private
   * @param {Object} args - The arguments to be merged.
   * @returns {Object} The merged arguments for the Todo.
   */
  static #mergeObjects(args) {
    return Object.assign({}, this.args, args);
  }
}


(function () {
  this.App || (this.App = {});
  this.App.Todo = Todo;
}).call(this);

