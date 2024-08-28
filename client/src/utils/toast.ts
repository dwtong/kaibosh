import { type Options, toast as bulmaToast } from "bulma-toast"

export type ToastOptions = {
  message: string
  type?: Options["type"]
}

export function toast({ message, type = "is-primary" }: ToastOptions): void {
  const options: Options = {
    message,
    type,
    duration: 3000,
    position: "top-center",
  }

  bulmaToast(options)
}
