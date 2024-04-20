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
  },
  append: function (id) {
    this.perform('append', { id: id, target: 'todos' });
  },
  prepend: function (id) {
    this.perform('prepend', { id: id, target: 'todos' });
  },
  update: function (id) {
    this.perform('update', { id: id, target: 'todos' });
  },
});
