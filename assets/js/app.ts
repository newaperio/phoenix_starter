// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import Alpine from "alpinejs"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"
import { s3Uploader } from "./uploads"

declare global {
  interface Window {
    Alpine: Alpine
    liveSocket: LiveSocket
  }
}

interface Alpine {
  clone: (from?: unknown, to?: HTMLElement) => unknown
}

interface AlpineHTMLElement {
  __x?: unknown
  _x_dataStack?: unknown
}

// Initialize Alpine
window.Alpine = Alpine
Alpine.start()

const csrfTokenTag = document.querySelector("meta[name='csrf-token']")
const csrfToken = csrfTokenTag ? csrfTokenTag.getAttribute("content") : ""
const liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if ((from as AlpineHTMLElement)._x_dataStack) {
        window.Alpine.clone(from, to)
      }
      return true
    },
  },
  params: { _csrf_token: csrfToken },
  uploaders: { S3: s3Uploader },
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", () => NProgress.start())
window.addEventListener("phx:page-loading-stop", () => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket
