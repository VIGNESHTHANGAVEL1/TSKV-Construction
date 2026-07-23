(function () {
  'use strict';

  // Header scroll effect
  const header = document.getElementById('header');
  window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 50);
  });

  // Mobile menu toggle
  const menuToggle = document.getElementById('menuToggle');
  const nav = document.getElementById('nav');

  menuToggle.addEventListener('click', () => {
    menuToggle.classList.toggle('active');
    nav.classList.toggle('open');
  });

  document.querySelectorAll('.header__menu a').forEach(link => {
    link.addEventListener('click', () => {
      menuToggle.classList.remove('active');
      nav.classList.remove('open');
    });
  });

  // Active nav link on scroll
  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('.header__menu a');

  function updateActiveNav() {
    const scrollPos = window.scrollY + 100;
    sections.forEach(section => {
      const top = section.offsetTop;
      const height = section.offsetHeight;
      const id = section.getAttribute('id');
      if (scrollPos >= top && scrollPos < top + height) {
        navLinks.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === `#${id}`) {
            link.classList.add('active');
          }
        });
      }
    });
  }

  window.addEventListener('scroll', updateActiveNav);

  // Hero background crossfade (content stays fixed)
  const slides = document.querySelectorAll('.hero__slide');
  let currentSlide = 0;

  function goToSlide(index) {
    if (!slides.length) return;
    slides[currentSlide].classList.remove('active');
    currentSlide = (index + slides.length) % slides.length;
    slides[currentSlide].classList.add('active');
  }

  if (slides.length > 1) {
    setInterval(() => goToSlide(currentSlide + 1), 7000);
  }

  // Stats counter animation
  const statsSection = document.querySelector('.stats');
  let statsAnimated = false;

  function animateCounters() {
    if (statsAnimated) return;
    const rect = statsSection.getBoundingClientRect();
    if (rect.top < window.innerHeight && rect.bottom > 0) {
      statsAnimated = true;
      document.querySelectorAll('.stats__number').forEach(counter => {
        const target = parseInt(counter.getAttribute('data-target'), 10);
        const duration = 2000;
        const step = target / (duration / 16);
        let current = 0;

        const update = () => {
          current += step;
          if (current >= target) {
            counter.textContent = target;
          } else {
            counter.textContent = Math.floor(current);
            requestAnimationFrame(update);
          }
        };
        update();
      });
    }
  }

  window.addEventListener('scroll', animateCounters);
  animateCounters();

  // Contact form
  const contactForm = document.getElementById('contactForm');
  contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const formData = new FormData(contactForm);
    const name = formData.get('name');
    const email = formData.get('email');
    const phone = formData.get('phone');
    const message = formData.get('message');

    const subject = encodeURIComponent(`Enquiry from ${name} - TSKV Construction`);
    const body = encodeURIComponent(
      `Name: ${name}\nEmail: ${email}\nPhone: ${phone || 'N/A'}\n\nMessage:\n${message}`
    );

    window.location.href = `mailto:tskvconstruction@gmail.com?subject=${subject}&body=${body}`;
    contactForm.reset();
  });

  // Smooth reveal on scroll
  const revealElements = document.querySelectorAll(
    '.service__card, .why__item, .project__card, .client__card, .vm__card'
  );

  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
          revealObserver.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.1 }
  );

  revealElements.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    revealObserver.observe(el);
  });
})();
