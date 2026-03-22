describe('RenderErrors', function () {
  beforeEach(function () {
    document.body.innerHTML = [
      '<div id="form-errors"></div>',
      '<form id="todo">',
      '  <input id="todo_title" name="todo[title]" class="form-control" />',
      '  <input id="todo_description" name="todo[description]" class="form-control" />',
      '  <select id="todo_status" name="todo[status]" class="form-control"><option value="pending">Pending</option></select>',
      '</form>'
    ].join('');
  });

  afterEach(function () {
    document.body.innerHTML = '';
  });

  it('uses default selector strategy and focuses the first error field', function () {
    const controller = new RenderErrors({
      form: '#todo',
      errorContainer: '#form-errors',
      fields: ['title', 'description', 'status'],
      errors: '["description", "status"]',
      render: '<ul><li>Description is required</li></ul>',
      fieldDomPrefix: 'todo'
    });

    controller.render();

    expect($('#form-errors').html()).toContain('Description is required');
    expect($('#todo_description').hasClass('is-invalid')).toBeTrue();
    expect($('#todo_status').hasClass('is-invalid')).toBeTrue();
    expect($('#todo_title').hasClass('is-invalid')).toBeFalse();
    expect(document.activeElement.id).toBe('todo_description');
  });

  it('supports custom input selector while keeping focus behavior', function () {
    const controller = new RenderErrors({
      form: '#todo',
      errorContainer: '#form-errors',
      fields: ['title', 'description', 'status'],
      errors: ['status'],
      render: '<ul><li>Status is required</li></ul>',
      inputSelector: function (field) {
        return `[name="todo[${field}]"]`;
      }
    });

    $('#todo_title').addClass('is-invalid');
    controller.render();

    expect($('#todo_status').hasClass('is-invalid')).toBeTrue();
    expect($('#todo_title').hasClass('is-invalid')).toBeFalse();
    expect(document.activeElement.id).toBe('todo_status');
  });

  it('falls back to empty list and warns on malformed JSON-like payload', function () {
    spyOn(console, 'warn');
    $('#todo_title').addClass('is-invalid');

    const controller = new RenderErrors({
      form: '#todo',
      errorContainer: '#form-errors',
      fields: ['title', 'description', 'status'],
      errors: '{"title":',
      render: '<ul><li>Invalid payload</li></ul>'
    });

    controller.render();

    expect(console.warn).toHaveBeenCalledWith('[RenderErrors] Failed to parse errors payload. Falling back to empty error list.');
    expect($('#todo_title').hasClass('is-invalid')).toBeFalse();
    expect($('#todo_description').hasClass('is-invalid')).toBeFalse();
    expect($('#todo_status').hasClass('is-invalid')).toBeFalse();
  });
});
