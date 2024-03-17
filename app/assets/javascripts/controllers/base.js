/**
 * Represents the base controller class.
 */
class Base {
  /**
   * Initializes a new instance of the Base class.
   * @param {string} notice - The notice to display.
   * @return {Alert} - Alert instance.
   */
  static index(notice) {
    Alert.add(notice)
  }
}


