import { formatDate, show_error_messages, remove_children } from "./export_function";

function parts_register() {
  const form = document.getElementById('parts_register_form');
  if (!form) return null;

  form.addEventListener('submit', (e) => {
    e.preventDefault();

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
    }).catch(err => console.log(err));
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
  checkBox.value = false;
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

window.addEventListener('turbo:load', parts_register);
window.addEventListener('turbo:render', parts_register);