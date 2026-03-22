describe('BroadcastHubJQueryController', function () {
  beforeEach(function () {
    document.body.innerHTML = [
      '<ul id="todos">',
      '  <li id="todo_1">Old 1</li>',
      '  <li id="todo_2">Old 2</li>',
      '</ul>',
      '<div id="target">Old target</div>'
    ].join('');
  });

  afterEach(function () {
    document.body.innerHTML = '';
  });

  it('appends content to target', function () {
    var controller = new BroadcastHubJQueryController(window.jQuery);

    controller.apply({ action: 'append', target: '#todos', content: '<li id="todo_3">New 3</li>' });

    expect($('#todo_3').length).toBe(1);
    expect($('#todos').children().length).toBe(3);
  });

  it('prepends content to target', function () {
    var controller = new BroadcastHubJQueryController(window.jQuery);

    controller.apply({ action: 'prepend', target: '#todos', content: '<li id="todo_0">New 0</li>' });

    expect($('#todos').children().first().attr('id')).toBe('todo_0');
  });

  it('updates by id first, then target fallback', function () {
    var controller = new BroadcastHubJQueryController(window.jQuery);

    controller.apply({
      action: 'update',
      target: '#target',
      id: 'todo_2',
      content: '<li id="todo_2">Updated 2</li>'
    });

    expect($('#todo_2').text()).toBe('Updated 2');

    controller.apply({
      action: 'update',
      target: '#target',
      id: 'missing',
      content: '<span>Fallback update</span>'
    });

    expect($('#target').html()).toBe('<span>Fallback update</span>');
  });

  it('removes by id first, then target fallback', function () {
    var controller = new BroadcastHubJQueryController(window.jQuery);

    controller.apply({ action: 'remove', target: '#target', id: 'todo_1' });

    expect($('#todo_1').length).toBe(0);
    expect($('#target').length).toBe(1);

    controller.apply({ action: 'remove', target: '#target', id: 'missing' });

    expect($('#target').length).toBe(0);
  });

  it('ignores invalid payload and warns in development', function () {
    var warnSpy = spyOn(window.console, 'warn');
    var controller = new BroadcastHubJQueryController(window.jQuery, { env: 'development' });

    controller.apply({ action: null, target: null });

    expect(warnSpy).toHaveBeenCalledWith('[BroadcastHub] Invalid payload ignored.');
    expect($('#todos').children().length).toBe(2);
  });
});

describe('BroadcastHubSubscription', function () {
  it('raises when resource is missing', function () {
    var fakeConsumer = {
      subscriptions: {
        create: function () {}
      }
    };
    var controller = { apply: function () {} };
    var subscription = new BroadcastHubSubscription(fakeConsumer, controller);

    expect(function () {
      subscription.subscribe('');
    }).toThrowError('resource is required');
  });

  it('subscribes with required resource and optional tenant', function () {
    var createSpy = jasmine.createSpy('create').and.returnValue({ identifier: 'ok' });
    var fakeConsumer = {
      subscriptions: {
        create: createSpy
      }
    };
    var controller = { apply: jasmine.createSpy('apply') };
    var subscription = new BroadcastHubSubscription(fakeConsumer, controller);

    subscription.subscribe('todo', 't1');

    expect(createSpy).toHaveBeenCalled();
    expect(createSpy.calls.argsFor(0)[0]).toEqual({
      channel: 'BroadcastHub::StreamChannel',
      resource: 'todo',
      tenant: 't1'
    });

    var handlers = createSpy.calls.argsFor(0)[1];
    handlers.received({ action: 'append' });
    expect(controller.apply).toHaveBeenCalledWith({ action: 'append' });

    subscription.subscribe('todo');
    expect(createSpy.calls.argsFor(1)[0]).toEqual({
      channel: 'BroadcastHub::StreamChannel',
      resource: 'todo'
    });
  });
});
