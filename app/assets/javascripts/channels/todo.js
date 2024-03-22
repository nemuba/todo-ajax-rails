App.todo_channel = App.cable.subscriptions.create("TodoChannel", {
  connected: function () {
    console.log('connected');
  },

  disconnected: function () {
    console.log('connected');
  },

  received: function ({ action, target, content, id, field }) {
    switch (action) {
      case 'append' || 'prepend':
        App.Todo[action](target, content);
        break;
      case 'update':
        App.Todo.update(target, id, content);
        break;
      case 'remove':
        App.Todo.remove(target, id);
        break;
      case 'inline':
        App.Todo.renderInline(target, id, field, content);
        break;
    }
  }
});
