// The server handles saving and scoring. JavaScript adds small conveniences.
document.querySelectorAll('[data-confirm]').forEach(function (button) {
  button.addEventListener('click', function (event) {
    if (!window.confirm(button.getAttribute('data-confirm'))) event.preventDefault();
  });
});

// Highlight the current page in both desktop and dedicated phone navigation.
document.querySelectorAll('nav a').forEach(function (link) {
  if (link.pathname === window.location.pathname) link.setAttribute('aria-current', 'page');
});

// Native details elements work without JavaScript; this adds recall feedback.
document.querySelectorAll('.flashcard details').forEach(function (card) {
  card.addEventListener('toggle', function () {
    var label = card.querySelector('summary');
    label.textContent = card.open ? 'Hide answer and try again' : 'Reveal answer';
  });
});
