export function quantityLabel(quantityString: string) {
  const quantity = parseFloat(quantityString)

  if (quantity === 1.0) {
    return "1 box"
  } else if (quantity > 1.0) {
    return `${parseInt(quantityString)} boxes`
  } else if (quantity > 0.0 && quantity < 1.0) {
    return `1/${parseInt(`${1.0 / quantity}`)} box`
  } else {
    return "no max"
  }
}
