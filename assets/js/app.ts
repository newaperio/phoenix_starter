// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import "alpinejs"
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
}

const csrfTokenTag = document.querySelector("meta[name='csrf-token']")
const csrfToken = csrfTokenTag ? csrfTokenTag.getAttribute("content") : ""
const liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if ((from as AlpineHTMLElement).__x) {
        window.Alpine.clone((from as AlpineHTMLElement).__x, to)
        return false
      }

      return false
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
