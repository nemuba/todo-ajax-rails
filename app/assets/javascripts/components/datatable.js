
class Datatable {
  constructor(table) {
    this.table = table;
    this.target = $(table).data('target');
    this.url = $(table).data('url');
    this.init();
    this.reload();
  }

  init() {
    this.load();

    setTimeout(() => {
      $.get(this.url).done((data) => {
        this.render(data);
      });
    }, 1000);
  }

  reload() {
    $(`${this.table} #btn-reload`).on('click', () => {
      this.load();

      setTimeout(() => {
        $.get(this.url).done((data) => {
          this.render(data);
        });
      }, 1000);
    });
  }

  load() {
    $(this.target).html(this.loadTemplate());
  }

  loadTemplate() {
    return `
      <tr>
        <td colspan="6" class="text-center">
        <div class="d-flex align-items-center fade">
          <strong>Loading...</strong>
          <div class="spinner-border ms-auto" role="status" aria-hidden="true"></div>
        </div>
        </td>
      </tr>
    `;
  }

  render(data) {
    App.Todo.renderTodos(data);
  }
}

(function () {
  this.App || (this.App = {});

  App.Datatable = Datatable
}).call(this);
