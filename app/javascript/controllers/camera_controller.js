import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "input"]

  connect() {
    navigator.mediaDevices.getUserMedia({
      video: {
        facingMode: "environment",
        aspectRatio: 9 / 16,
        width: { ideal: 720 },   // ou 1080, selon la qualité voulue
        height: { ideal: 1280 }
        }})
    .then(stream => {
      this.videoTarget.srcObject = stream
    })
  }

  capture() {
    const video = this.videoTarget

    // Taille réelle du flux vidéo
    const videoWidth = video.videoWidth
    const videoHeight = video.videoHeight

    // Calcul du crop pour obtenir du 9:16
    const targetRatio = 9 / 16
    let cropWidth = videoWidth
    let cropHeight = videoWidth / targetRatio

    if (cropHeight > videoHeight) {
      cropHeight = videoHeight
      cropWidth = videoHeight * targetRatio
    }

    const cropX = (videoWidth - cropWidth) / 2
    const cropY = (videoHeight - cropHeight) / 2

    // Canvas au format 9:16
    const canvas = document.createElement("canvas")
    canvas.width = cropWidth
    canvas.height = cropHeight
    const ctx = canvas.getContext("2d")

    ctx.drawImage(
      video,
      cropX, cropY, cropWidth, cropHeight, // source crop
      0, 0, cropWidth, cropHeight          // destination
    )

    const dataUrl = canvas.toDataURL("image/png")
    this.inputTarget.value = dataUrl
    document.getElementById("photo-form").submit()
  }
}
