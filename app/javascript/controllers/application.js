import { Application } from "@hotwired/stimulus"
import TooltipController from "./tooltip_controller"

const application = Application.start()
application.register("tooltip", TooltipController)

application.debug = false
window.Stimulus = application

export { application }
