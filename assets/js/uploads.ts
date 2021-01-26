interface LiveViewUploadEntry {
  error: () => void
  file: File
  meta: { method: string; url: string; fields: { [key: string]: string } }
  progress: (percent: number) => void
}

const s3Uploader = (
  entries: [LiveViewUploadEntry],
  onViewError: (callback: () => void) => void,
): void => {
  entries.forEach((entry) => {
    const { method, url, fields } = entry.meta

    const formData = new FormData()
    Object.entries(fields).forEach(([key, val]) => formData.append(key, val))
    formData.append("file", entry.file)

    const xhr = new XMLHttpRequest()
    onViewError(() => xhr.abort())
    xhr.onload = () =>
      xhr.status === 204 ? entry.progress(100) : entry.error()
    xhr.onerror = () => entry.error()
    xhr.upload.addEventListener("progress", (event) => {
      if (event.lengthComputable) {
        const percent = Math.round((event.loaded / event.total) * 100)
        if (percent < 100) {
          entry.progress(percent)
        }
      }
    })

    xhr.open(method, url, true)
    xhr.send(formData)
  })
}

export { s3Uploader }
