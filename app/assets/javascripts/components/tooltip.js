
/**
 * Represents a Tooltip component.
 * @class
 */
class Tooltip {
  constructor() {
    this.tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    this.init();
  }

  /**
   * Initializes the tooltips.
   */
  init() {
    this.tooltips.forEach(tooltip => {
      new bootstrap.Tooltip(tooltip)
    });
  }
}

$('turbolinks:load', () => {
  new Tooltip();
});
