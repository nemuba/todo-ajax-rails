describe('ResourceTableController', function () {
  function buildConfig(overrides) {
    const base = {
      resourceName: 'todo',
      fields: ['title', 'description', 'status'],
      selectors: {
        tableBody: '#todos',
        emptyRows: '#empty_rows',
        total: '#todos-total',
        modal: '#todo-modal',
        modalTitle: '#todo-modal .modal-title',
        modalBody: '#todo-modal #modal-body',
        form: '#todo',
        errorContainer: '#todo-modal #form-errors'
      },
      messages: {
        total: 'Total de registros: %{count}'
      }
    };

    return Object.assign({}, base, overrides || {});
  }

  beforeEach(function () {
    document.body.innerHTML = [
      '<table>',
      '  <tbody id="todos">',
      '    <tr id="todo-1"><td id="todo-title-1">Original</td></tr>',
      '  </tbody>',
      '</table>',
      '<tr id="empty_rows" style="display: table-row;"><td>nenhum registro</td></tr>',
      '<div id="todos-total"></div>',
      '<div id="todo-modal"><div class="modal-title"></div><div id="modal-body"></div><div id="form-errors"></div></div>',
      '<form id="todo"></form>',
      '<button id="btn-more-todo-1" class="btn"></button>'
    ].join('');

    this.originalTooltip = window.Tooltip;
    window.Tooltip = jasmine.createSpy('Tooltip');

    this.originalModal = window.Modal;
    window.Modal = function () {
      return { show: function () {} };
    };

    this.originalFadeIn = $.fn.fadeIn;
    this.originalFadeOut = $.fn.fadeOut;
    $.fn.fadeIn = function () { return this; };
    $.fn.fadeOut = function (callback) {
      if (typeof callback === 'function') {
        callback.call(this);
      }

      return this;
    };
  });

  afterEach(function () {
    $.fn.fadeIn = this.originalFadeIn;
    $.fn.fadeOut = this.originalFadeOut;
    window.Tooltip = this.originalTooltip;
    window.Modal = this.originalModal;
    document.body.innerHTML = '';
  });

  it('applies API defaults including rowSelector', function () {
    const controller = new ResourceTableController(buildConfig());

    expect(controller.config.rowSelector).toBe('tr[id^="todo-"]');
    expect(controller.rows()).toBe(1);

    controller.append('<tr id="todo-2"></tr>');

    expect(controller.rows()).toBe(2);
    expect($('#todos-total').text()).toBe('Total de registros: 2');
    expect($('#empty_rows').is(':visible')).toBeFalse();
  });

  it('renders and toggles more rows', function () {
    const controller = new ResourceTableController(buildConfig());
    const getSpy = spyOn($, 'get').and.returnValue($.Deferred().resolve());

    controller.renderMore(1, '<tr id="more-todo-1"><td>More</td></tr>');

    expect($('#todos #more-todo-1').length).toBe(1);

    controller.toggleMore(1, '/todos/1/more');

    expect($('#todos #more-todo-1').length).toBe(0);
    expect($('#btn-more-todo-1').hasClass('active')).toBeTrue();

    controller.toggleMore(1, '/todos/1/more');

    expect(getSpy).toHaveBeenCalledWith('/todos/1/more');
    expect($('#btn-more-todo-1').hasClass('active')).toBeFalse();
  });

  it('renders errors using controller defaults', function () {
    const controller = new ResourceTableController(buildConfig());
    $('#todo').html([
      '<input id="todo_title" />',
      '<input id="todo_description" />',
      '<input id="todo_status" />'
    ].join(''));

    controller.renderErrors('<ul><li>Title</li></ul>', ['title']);

    expect($('#todo-modal #form-errors').html()).toContain('Title');
    expect($('#todo_title').hasClass('is-invalid')).toBeTrue();
    expect($('#todo_description').hasClass('is-invalid')).toBeFalse();
  });
});

describe('Todo legacy update API', function () {
  beforeEach(function () {
    document.body.innerHTML = [
      '<table>',
      '  <tbody id="todos">',
      '    <tr id="todo-1"><td id="todo-title-1">Old title</td></tr>',
      '  </tbody>',
      '</table>',
      '<tr id="empty_rows" style="display: none;"><td>nenhum registro</td></tr>',
      '<div id="todos-total"></div>',
      '<div id="todo-modal"><div class="modal-title"></div><div id="modal-body"></div><div id="form-errors"></div></div>',
      '<form id="todo"></form>'
    ].join('');

    this.originalTooltip = window.Tooltip;
    window.Tooltip = jasmine.createSpy('Tooltip');

    this.originalModal = window.Modal;
    window.Modal = function () {
      return { show: function () {} };
    };

    this.originalFadeIn = $.fn.fadeIn;
    $.fn.fadeIn = function () { return this; };
  });

  afterEach(function () {
    $.fn.fadeIn = this.originalFadeIn;
    window.Tooltip = this.originalTooltip;
    window.Modal = this.originalModal;
    document.body.innerHTML = '';
  });

  it('supports update(target, id, rowHtml) with deprecation warnings', function () {
    spyOn(console, 'warn');
    const todo = new Todo('todos');

    todo.update('#legacy-target', 1, '<tr id="todo-1"><td id="todo-title-1">Updated title</td></tr>');

    expect(console.warn).toHaveBeenCalledWith('[DEPRECATION] App.Todo.update(target, id, rowHtml) is deprecated. Use App.Todo.update(id, rowHtml).');
    expect(console.warn).toHaveBeenCalledWith('[DEPRECATION] Ignoring legacy target argument: #legacy-target. Using #todos instead.');
    expect($('#todo-title-1').text()).toBe('Updated title');
    expect($('#todos-total').text()).toBe('Total de registros: 1');
  });
});
