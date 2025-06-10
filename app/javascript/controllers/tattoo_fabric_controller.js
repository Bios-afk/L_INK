// app/javascript/controllers/tattoo_fabric_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  static values = { photoUrl: String, tattooUrl: String }

  connect() {
    if (!window.fabric) {
      alert("Fabric.js n'est pas chargé !");
      return;
    }
    this.fabricCanvas = new fabric.Canvas(this.canvasTarget)
    this.loadBackgroundAndTattoo()
  }

  loadBackgroundAndTattoo() {
    fabric.Image.fromURL(this.photoUrlValue, (bgImg) => {
      this.fabricCanvas.setWidth(bgImg.width)
      this.fabricCanvas.setHeight(bgImg.height)
      this.fabricCanvas.setBackgroundImage(bgImg, this.fabricCanvas.renderAll.bind(this.fabricCanvas))

      fabric.Image.fromURL(this.tattooUrlValue, (tattooImg) => {
        tattooImg.set({
          left: this.fabricCanvas.width / 2,
          top: this.fabricCanvas.height / 2,
          originX: "center",
          originY: "center",
          opacity: 0.7,
          selectable: true,
          hasControls: true,
          hasBorders: true,
        })

        // Redimensionne si trop grand
        const maxWidth = this.fabricCanvas.width * 0.5
        const scale = maxWidth / tattooImg.width
        if (scale < 1) tattooImg.scale(scale)

        this.fabricCanvas.add(tattooImg)
        this.fabricCanvas.setActiveObject(tattooImg)
        this.fabricCanvas.renderAll()
      }, { crossOrigin: 'anonymous' })
    }, { crossOrigin: 'anonymous' })
  }

  download() {

    if (!this.fabricCanvas) return;
    console.log("Téléchargement de l'image...");
    const dataURL = this.fabricCanvas.toDataURL({
      format: "png",
      quality: 1.0
    });
    const link = document.createElement('a');
    link.href = dataURL;
    link.download = 'tattoo-photo.png';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
}
