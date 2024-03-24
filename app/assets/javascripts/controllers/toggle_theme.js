
class ToggleTheme {
  static setTheme(theme) {
    $('html').attr('data-bs-theme', theme)
    localStorage.setItem('theme', theme)
    this.setBtnTheme(theme)
  }

  static setBtnTheme(theme) {
    $('#bd-theme').html(theme === 'dark' ? this.iconDark() : this.iconLight())
  }

  static iconDark() {
    return '<i class="bi bi-moon-fill"></i>';
  }

  static iconLight() {
    return '<i class="bi bi-sun-fill"></i>';
  }
}

(function () {
  this.App || (this.App = {});

  this.App.ToggleTheme = ToggleTheme
}).call(this);
