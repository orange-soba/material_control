const displayText = () => {
  const editButtons = document.querySelectorAll('.edit-btn');
  if (!editButtons) return null;

  editButtons.forEach((editBtn) => {
    const hiddenText = editBtn.nextElementSibling;
    editBtn.addEventListener('mouseover', () => {
      hiddenText.setAttribute('style', 'display: block;');
    });
    editBtn.addEventListener('mouseout', () => {
      hiddenText.setAttribute('style', 'display: none;');
    });
  });
};

window.addEventListener("turbo:load", displayText);