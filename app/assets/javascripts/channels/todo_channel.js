(function (global) {
  function wireTodoChannel(consumer, $) {
    var controller = new BroadcastHubJQueryController($);
    var subscription = new BroadcastHubSubscription(consumer, controller);

    return subscription.subscribe('todo');
  }

  global.TodoChannel = global.TodoChannel || {};
  global.TodoChannel.wire = wireTodoChannel;

  if (global.App && global.App.cable && global.jQuery) {
    global.App.todo_channel = wireTodoChannel(global.App.cable, global.jQuery);
  }
})(this);
