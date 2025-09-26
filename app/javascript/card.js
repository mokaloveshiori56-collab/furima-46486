const pay = () => {
  const form = document.getElementById("purchase_form"); 
  if (!form) return;

  form.addEventListener("submit", (e) => {
    e.preventDefault(); 

     const tokenInput = document.getElementById("token"); 

     if (!tokenInput) {
      console.error("エラー: ID 'token' の要素が見つかりませんでした。");
      return; // 要素がないため処理を中断
    }
    
    // 値を読み込む
    console.log("トークンの値 (hidden):", tokenInput.value); 
    
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("DOMContentLoaded", pay);