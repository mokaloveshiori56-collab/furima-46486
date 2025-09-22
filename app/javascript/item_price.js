const price = () => {
  const priceInput = document.getElementById("item-price");
  if (!priceInput) return;

  priceInput.addEventListener("input", () => {
    const inputValue = priceInput.value;
    const addTaxDom = document.getElementById("add-tax-price");
    const profitDom = document.getElementById("profit");

    const priceValue = Number(inputValue);
    if (isNaN(priceValue)) {
      addTaxDom.innerHTML = "";
      profitDom.innerHTML = "";
      return;
    }
      
    const tax = Math.floor(priceValue * 0.1); // priceValueを使用
    const profit = Math.floor(priceValue - tax); // priceValueを使用
      
    addTaxDom.innerHTML = tax;
    profitDom.innerHTML = profit;
 });
};

window.addEventListener("turbo:load", price);
window.addEventListener("turbo:render", price);
