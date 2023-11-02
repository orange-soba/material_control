function parts_register() {
  const form = document.getElementById('parts_register_form');
  if (!form) return null;

  form.addEventListener('turbo:submit-start', (e) => {
    e.preventDefault();

    // 送信ボタンを無効化
    const submitButton = form.querySelector('input[type="submit"]');
    submitButton.disabled = true;

    const formData = new FormData(form);
    const url = '/parts';
    const post_options = {
      method: 'post',
      body: formData
    };

    fetch(url, post_options).then(response => {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error(`Request failed: ${response.status}`);
      }
    }).then(data => {
      handle_data(data);
    }).catch(err => console.log(err)).finally(() => {
      // 送信ボタンを有効化
      submitButton.disabled = false;
    });
  });
};

function handle_data(data) {
  const part = data.part;
  if (data.success) {
    // 入力の初期化
    reset_input();
    
    // htmlの挿入
    const historyData = document.getElementById('parts-history-data');
    const html = create_html(part);
    historyData.insertAdjacentHTML('afterbegin', html);

    // エラー情報の非表示化
    const area = document.getElementById('error-messages-area');
    area.setAttribute('style', 'display:none;');
    const lists = document.getElementById('error-messages-lists');
    remove_children(lists);
  } else {
    show_error_messages(data.errors);
  }
};

function reset_input() {
  const inputName = document.getElementById('part_name');
  const inputStock = document.getElementById('part_stock');
  const checkBox = document.getElementById('part_finished');
  inputName.value = "";
  inputStock.value = 0;
  checkBox.checked = false;
};

function create_html(part) {
  let html = `<tr><td>${part.name}</td>
                <td class="history-stock">${part.stock}</td>`;
  if (part.finished) {
    html += '<td>完成品</td>';
  } else {
    html += '<td>部品</td>';
  }
  const date = new Date(part.created_at);
  html += `<td>${formatDate(date)}</td></tr>`;

  return html;
};

function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
};

function show_error_messages(messages) {
  const area = document.getElementById('error-messages-area');
  const lists = document.getElementById('error-messages-lists');

  area.removeAttribute('style', 'display:none;');
  remove_children(lists)
  messages.forEach((message) => {
    const html = `<li class='error-message'>!${message}!</li>`
    lists.insertAdjacentHTML('beforeend', html);
  });
};

function remove_children(lists) {
  while(lists.lastChild) {
    lists.removeChild(lists.lastChild);
  }
};


window.addEventListener('turbo:load', parts_register);

// 二重登録が起きたり起きなかったりという問題が以下のコメントアウトで解決。
// もしまた同じ問題や別の問題が起きた時のために念の為コメントアウトの状態にしておく
window.addEventListener('turbo:render', parts_register);