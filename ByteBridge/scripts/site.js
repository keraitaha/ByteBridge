document.querySelectorAll('[data-confirm]').forEach(function (button) {
  button.addEventListener('click', function (event) {
    if (!window.confirm(button.getAttribute('data-confirm'))) event.preventDefault();
  });
});

document.querySelectorAll('nav a').forEach(function (link) {
  if (link.pathname === window.location.pathname) link.setAttribute('aria-current', 'page');
});

document.querySelectorAll('.flashcard details').forEach(function (card) {
  card.addEventListener('toggle', function () {
    var label = card.querySelector('summary');
    label.textContent = card.open ? 'Hide answer and try again' : 'Reveal answer';
  });
});
