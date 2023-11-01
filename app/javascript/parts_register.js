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
    const inputName = document.getElementById('part_name');
    const inputStock = document.getElementById('part_stock');
    const checkBox = document.getElementById('part_finished');
    inputName.value = "";
    inputStock.value = 0;
    checkBox.value = false;
    const historyData = document.getElementById('parts-history-data');
    const html = create_html(part);
    historyData.insertAdjacentHTML('afterbegin', html);
  } else {
    show_error_messages(data.errors);
  }
};

function create_html(part) {
  let html = `<tr><td>${part.name}</td>
                <td class="parts-history-stock">${part.stock}</td>`;
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