describe('todo_channel wiring', function () {
  var originalApp;
  var createSpy;

  function loadTodoChannel(done) {
    window.jQuery.ajax({
      url: '/assets/channels/todo_channel.js',
      dataType: 'script',
      cache: false
    }).done(function () {
      done();
    }).fail(function (_, __, errorThrown) {
      done.fail(errorThrown || 'failed to load todo_channel.js');
    });
  }

  beforeEach(function () {
    originalApp = window.App;
    createSpy = jasmine.createSpy('create').and.returnValue({ identifier: 'ok' });
    window.App = {
      cable: {
        subscriptions: {
          create: createSpy
        }
      }
    };
  });

  afterEach(function () {
    window.App = originalApp;
  });

  it('subscribes to BroadcastHub todo stream via App.cable', function (done) {
    loadTodoChannel(function () {
      expect(createSpy).toHaveBeenCalled();
      expect(createSpy.calls.argsFor(0)[0]).toEqual({
        channel: 'BroadcastHub::StreamChannel',
        resource: 'todo'
      });
      done();
    });
  });
});
