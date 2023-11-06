function materials_register() {
  const form = document.getElementById('materials-register-form');
  if (!form) return null;

  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const formData = new FormData(form);
    const url = '/materials';
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
  const material = data.material;
  if (data.success) {
    // 入力の初期化
    reset_input();

    // htmlの挿入
    const historyData = document.getElementById('materials-history-data');
    const html = create_html(material);
    historyData.insertAdjacentHTML('afterbegin', html);

    // エラー情報の非表示化
    const area = document.getElementById('error-messages-area');
    area.setAttribute('style', 'display:none;');
    const lists = document.getElementById('error-messages-lists');
    remove_children(lists);
  } else {
    show_error_messages(data.errors);
  };
};

function reset_input() {
  const inputType = document.getElementById('material_material_type');
  const inputCategory = document.getElementById('material_category');
  const inputThickness = document.getElementById('material_thickness');
  const inputWidth = document.getElementById('material_width');
  const inputOption = document.getElementById('material_option');
  const inputLength = document.getElementById('material_length');
  const inputStock = document.getElementById('material_stock');
  inputType.value = "";
  inputCategory.value = "";
  inputThickness.value = "";
  inputWidth.value = "";
  inputOption.value = "";
  inputLength.value = "";
  inputStock.value = 0.0;
};

function create_html(material) {
  let html = `<tr><td>${material.material_type} / ${material.category} / ${material.thickness} /`;
  if (material.width) {
    html += ` ${material.width} /`;
  } else {
    html += ' --- /';
  }
  if (material.option) {
    html += ` ${material.option} /`;
  } else {
    html += ' --- /';
  }
  html += ` ${material.length}</td><td class="history-stock">${material.stock}</td>`;
  const date = new Date(material.created_at);
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


window.addEventListener('turbo:load', materials_register);
// window.addEventListener('turbo:render', materials_register);