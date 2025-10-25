import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="step-dialog"
export default class extends Controller {
  static targets = ["step"]

  connect() {
    this.currentStep = 1;
  }

  showCurrentStep() {
    this.stepTargets.forEach((stepElement, index) => {
      if (index === this.currentStep - 1) {
        stepElement.style.display = "block";
      } else {
        stepElement.style.display = "none";
      }
    });
  }

  nextStep() {
    if (this.currentStep < this.stepTargets.length) {
      this.currentStep++;
      this.showCurrentStep();
    }
  }

  prevStep() {
    if (this.currentStep > 1) {
      this.currentStep--;
      this.showCurrentStep();
    }
  }
}
