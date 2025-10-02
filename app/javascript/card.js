const pay = () => {
  const publicKey = gon.public_key;
  // Payjpオブジェクトの初期化
  const payjp = Payjp(publicKey); 
  const elements = payjp.elements();
  
  // 各カード情報入力フィールドのDOMを取得・マウント
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('purchase_form'); 
  
  // フォーム送信時のイベントリスナー
  form.addEventListener("submit", (e) => {
    // フォームの標準送信を最初に止める！ (非同期処理のため必須)
    e.preventDefault(); 
    
    const submitBtn = document.getElementById("button");
    // ボタンを無効化し、二重送信と誤送信を防ぐ
    submitBtn.setAttribute("disabled", true); 

    // Payjpでトークンを生成
    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        // 🚨 失敗時: ボタンを有効に戻す
        submitBtn.removeAttribute("disabled"); 
        
        // エラーメッセージの表示 (例: カード情報エラー)
        // 必要に応じてここにエラーメッセージをページ内に表示する処理を追加
        console.error("Payjp Token Error:", response.error.message);

      } else {
        // ✅ 成功時: トークンをhiddenフィールドにセット
        const token = response.id;
        const tokenInput = document.getElementById("token"); 
        tokenInput.value = token;
        
        // フォーム送信を再開（ここでサーバーへデータが送られる）
        form.submit();
      }
      
      // 成功・失敗に関わらずカード情報をクリア（失敗時は再入力を促すためにも必要）
      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

    });
    // 🚨 注意: 非同期処理のPromiseの外側では form.submit() を実行してはいけません。
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);