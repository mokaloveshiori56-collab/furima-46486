const pay = () => {
  const publicKey = gon.public_key;
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();
  // 各カード情報入力フィールドのDOMを取得
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 各フィールドをHTMLの指定されたIDにマウント
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('purchase_form'); 
  if (!form) return; 

  form.addEventListener("submit", (e) => {
    // 1. フォームの標準送信を最初に止める！ (非同期処理のため必須)
    e.preventDefault(); 
    
    // 2. ボタンを無効化し、二重送信を防ぐ
    const submitBtn = document.getElementById("button");
    if (submitBtn) {
      submitBtn.setAttribute("disabled", true); 
    }

    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        // 🚨 失敗時: トークン生成失敗
        
        // ボタンを有効に戻す
        if (submitBtn) {
          submitBtn.removeAttribute("disabled"); 
        }
        
        // カード情報クリア（再入力を促す）
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        
        // ここでエラーメッセージをページ内に表示する処理を追加

      } else {
        // ✅ 成功時: トークンをhiddenフィールドにセットし、フォームを送信
        const token = response.id;
        
        // 既存の hidden field にトークンをセット（HTMLで f.hidden_field :token, id: "token" がある前提）
        const tokenInput = document.getElementById("token");
        tokenInput.value = token;
        
        // カード情報クリア
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();

        // 3. トークンがセットされた後でのみ、フォーム送信を実行！
        form.submit();
      }
    });
    // 🚨 非同期処理の外側では form.submit() を実行しない
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
