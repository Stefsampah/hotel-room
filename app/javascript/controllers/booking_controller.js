import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkin", "checkout", "totalPrice", "submitButton", "error"]
  static values = {
    roomPrice: Number
  }

  connect() {
    this.updatePrice()
    this.submitButton.disabled = true
    this.errorTarget.classList.add('d-none')
  }

  async checkAvailability() {
    if (!this.checkinTarget.value || !this.checkoutTarget.value) {
      this.submitButton.disabled = true
      return
    }

    try {
      this.submitButton.disabled = true
      this.submitButton.textContent = 'Vérification...'
      
      const response = await fetch(`/hotels/${this.hotelId}/rooms/${this.roomId}/check_availability`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          booking: {
            start_date: this.checkinTarget.value,
            end_date: this.checkoutTarget.value
          }
        })
      })

      const data = await response.json()
      
      if (data.available) {
        this.submitButton.disabled = false
        this.errorTarget.classList.add('d-none')
        this.totalPriceTarget.textContent = `Prix total: ${new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(data.total_price)}`
      } else {
        this.submitButton.disabled = true
        this.errorTarget.classList.remove('d-none')
        this.errorTarget.textContent = 'Cette chambre n\'est pas disponible pour les dates sélectionnées.'
      }
    } catch (error) {
      console.error('Erreur lors de la vérification de disponibilité:', error)
      this.errorTarget.classList.remove('d-none')
      this.errorTarget.textContent = 'Une erreur est survenue lors de la vérification de disponibilité.'
    } finally {
      this.submitButton.textContent = 'Réserver maintenant'
    }
  }

  updatePrice() {
    if (!this.checkinTarget.value || !this.checkoutTarget.value) {
      this.totalPriceTarget.textContent = 'Sélectionnez les dates'
      return
    }

    const startDate = new Date(this.checkinTarget.value)
    const endDate = new Date(this.checkoutTarget.value)
    const nights = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24))
    
    if (nights > 0) {
      const totalPrice = nights * this.roomPriceValue
      this.totalPriceTarget.textContent = `Prix total: ${new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR' }).format(totalPrice)}`
      this.checkAvailability()
    } else {
      this.totalPriceTarget.textContent = 'Veuillez sélectionner des dates valides'
      this.submitButton.disabled = true
    }
  }

  get hotelId() {
    return window.location.pathname.split('/')[2]
  }

  get roomId() {
    return window.location.pathname.split('/')[4]
  }
} 