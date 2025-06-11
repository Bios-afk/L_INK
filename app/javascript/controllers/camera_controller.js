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

    const width = video.clientWidth
    const height = video.clientHeight

    const canvas = document.createElement("canvas")
    canvas.width = width
    canvas.height = height
    const ctx = canvas.getContext("2d")

    // Symétrie axe Y (effet miroir)
    ctx.translate(width, 0)
    ctx.scale(-1, 1)
    ctx.drawImage(video, 0, 0, width, height)

    const dataUrl = canvas.toDataURL("image/png")
    this.inputTarget.value = dataUrl
    document.getElementById("photo-form").submit()
  }
}
