export default {
  quantityLabel(quantityString: string) {
    const quantity = parseFloat(quantityString);

    if (quantity === 1.0) {
      return "1 box (max)";
    } else if (quantity > 1.0) {
      return `${parseInt(quantityString)} boxes (max)`;
    } else if (quantity > 0.0 && quantity < 1.0) {
      return `1/${parseInt(`${1.0 / quantity}`)} box (max)`;
    } else {
      return "no limit";
    }
  }
};
