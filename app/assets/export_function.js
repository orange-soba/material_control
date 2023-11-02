export function formatDate(date) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
};

export function show_error_messages(messages) {
  const area = document.getElementById('error-messages-area');
  const lists = document.getElementById('error-messages-lists');

  area.removeAttribute('style', 'display:none;');
  remove_children(lists)
  messages.forEach((message) => {
    const html = `<li class='error-message'>!${message}!</li>`
    lists.insertAdjacentHTML('beforeend', html);
  });
};

export function remove_children(lists) {
  while(lists.lastChild) {
    lists.removeChild(lists.lastChild);
  }
};
