import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import "flatpickr/dist/flatpickr.css"

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      mode: "range",
      dateFormat: "Y-m-d",
      minDate: "today",
      locale: {
        firstDayOfWeek: 1
      }
    })
  }
} 