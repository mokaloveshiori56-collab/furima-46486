window.addEventListener('turbo:load', () => {
  const priceInput = document.getElementById("item-price");
  
  if (priceInput) {
    priceInput.addEventListener("input", () => {
      const inputValue = priceInput.value;

      console.log(`入力された金額: ${inputValue}`);

      const addTaxDom = document.getElementById("add-tax-price");
      const profitDom = document.getElementById("profit");

      console.log(`手数料表示要素: ${addTaxDom.id}`);
      console.log(`利益表示要素: ${profitDom.id}`);
 
      const tax = Math.floor(inputValue * 0.1);
      const profit = Math.floor(inputValue - tax);
      
      addTaxDom.innerHTML = tax;
      profitDom.innerHTML = profit;
    });
  }
});