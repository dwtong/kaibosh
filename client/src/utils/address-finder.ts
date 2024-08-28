/* eslint-disable @typescript-eslint/no-explicit-any */

declare global {
  interface Window {
    AddressFinder: {
      Widget: any
    }
  }
}

export function initAddressFinder(
  name: string = "address",
  callback: (val: string) => void,
) {
  let widget: any
  const initAddressFinder = function () {
    widget = new window.AddressFinder.Widget(
      document.getElementById(name),
      "A3XCU7TYNHVR48P6WK9G",
      "NZ",
      {
        address_params: {},
      },
    )

    widget.on("address:select", function (_fullAddress: any, metaData: any) {
      ;(document.getElementById(name) as any).value = metaData.a
      callback(metaData.a)
    })
  }

  const script = document.createElement("script")
  script.src = "https://api.addressfinder.io/assets/v3/widget.js"
  script.async = true
  script.onload = initAddressFinder
  document.body.appendChild(script)
}
