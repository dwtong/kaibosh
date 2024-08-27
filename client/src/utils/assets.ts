export function imagePath(imageName: string) {
  const images = import.meta.glob("@/assets/images/foods/*.png", {
    eager: true,
    as: "url",
  })

  const imagePath = Object.entries(images).find(([key]) =>
    key.includes(`${imageName}-min.png`),
  )?.[1]

  if (!imagePath) {
    throw new Error(`Image "${imageName}-min.png" not found.`)
  }

  return imagePath
}
