import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "input"]

  connect() {
    navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
      .then(stream => {
        this.videoTarget.srcObject = stream
      })
  }

  capture() {
    const video = this.videoTarget
    const canvas = document.createElement("canvas")
    canvas.width = video.videoWidth
    canvas.height = video.videoHeight
    const ctx = canvas.getContext("2d")

    // Symétrie axe Y (effet miroir)
    ctx.translate(canvas.width, 0)
    ctx.scale(-1, 1)
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height)

    const dataUrl = canvas.toDataURL("image/png")
    this.inputTarget.value = dataUrl
    document.getElementById("photo-form").submit()
  }
}
