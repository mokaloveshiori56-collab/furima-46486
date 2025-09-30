const pay = () => {
  const PAYJP_PUBLIC_KEY = window.PAYJP_PUBLIC_KEY;
  if (!PAYJP_PUBLIC_KEY) return; 

  Payjp.setPublicKey(PAYJP_PUBLIC_KEY);
  
  // 1. PAY.JPの初期化とElementsのセットアップ
  const payjp = Payjp(PAYJP_PUBLIC_KEY);
  const elements = payjp.elements();
  
  // 各カード情報入力フィールドのDOMを取得
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 各フィールドをHTMLの指定されたIDにマウント
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // 2. フォーム送信時のイベント処理
  const form = document.getElementById('purchase_form'); // フォームのIDに合わせて修正
  if (!form) return;

  form.addEventListener("submit", (e) => {
    e.preventDefault(); // デフォルトのフォーム送信を阻止！
    
    // 3. トークン生成処理の開始
    payjp.createToken(numberElement).then(function (response) {
      // response の中身をデバッグで確認する
      
      if (response.error) {
        // エラー処理: トークン生成失敗
        alert("カード情報に誤りがあります。");
        // サーバー側にエラーを返すため、そのままフォームを送信
        form.submit();
      } else {
        // 成功処理: トークンをフォームの既存の隠しフィールドに格納
        const token = response.id;
        
        // 既存の隠しフィールド (f.hidden_field :token, id: "token") を取得
        const tokenInput = document.getElementById("token"); 
        
        // トークンIDを隠しフィールドのvalueに設定
        tokenInput.value = token;

        // サーバーへフォームを送信
        form.submit();
      }
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);