App.todo_channel = App.cable.subscriptions.create("TodoChannel", {
  connected: function () {
    console.log('TodoChannel connected');
  },

  disconnected: function () {
    console.log('TodoChannel disconnected');
  },

  received: function ({ action, target, content, id, field }) {
    const stream = new Todo(target);
    switch (action) {
      case 'append' || 'prepend':
        stream[action](content);
        break;
      case 'update':
        stream[action](id, content)
        break;
      case 'remove':
        stream[action](id);
        break;
      case 'inline':
        stream.renderInline(id, field, content);
        break;
    }
  }
});
