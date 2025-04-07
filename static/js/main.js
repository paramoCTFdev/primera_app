// static/js/main.js

document.addEventListener('DOMContentLoaded', function() {
    // Navegación móvil
    const menuToggle = document.querySelector('.menu-toggle');
    const nav = document.querySelector('nav');
    
    if (menuToggle) {
        menuToggle.addEventListener('click', function() {
            nav.classList.toggle('active');
        });
    }
    
    // Cerrar el menú al hacer clic fuera de él
    document.addEventListener('click', function(event) {
        const isClickInsideNav = nav.contains(event.target);
        const isClickOnToggle = menuToggle.contains(event.target);
        
        if (!isClickInsideNav && !isClickOnToggle && nav.classList.contains('active')) {
            nav.classList.remove('active');
        }
    });
    
    // Animación suave al scroll para los enlaces de navegación
    const navLinks = document.querySelectorAll('nav a');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Solo aplicar a los enlaces internos
            if (this.getAttribute('href').startsWith('#')) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                if (targetElement) {
                    window.scrollTo({
                        top: targetElement.offsetTop - 80,
                        behavior: 'smooth'
                    });
                    
                    // Cerrar el menú móvil después de hacer clic
                    if (nav.classList.contains('active')) {
                        nav.classList.remove('active');
                    }
                }
            }
        });
    });
    
    // Slider de testimonios
    const testimonialSlider = document.querySelector('.testimonial-slider');
    
    if (testimonialSlider) {
        const testimonials = testimonialSlider.querySelectorAll('.testimonial');
        let currentTestimonial = 0;
        
        // Ocultar todos los testimonios excepto el primero
        testimonials.forEach((testimonial, index) => {
            if (index !== 0) {
                testimonial.style.display = 'none';
            }
        });
        
        // Función para mostrar el siguiente testimonio
        function showNextTestimonial() {
            testimonials[currentTestimonial].style.display = 'none';
            currentTestimonial = (currentTestimonial + 1) % testimonials.length;
            testimonials[currentTestimonial].style.display = 'block';
        }
        
        // Función para mostrar el testimonio anterior
        function showPrevTestimonial() {
            testimonials[currentTestimonial].style.display = 'none';
            currentTestimonial = (currentTestimonial - 1 + testimonials.length) % testimonials.length;
            testimonials[currentTestimonial].style.display = 'block';
        }
        
        // Crear controles de navegación
        const sliderControls = document.createElement('div');
        sliderControls.className = 'slider-controls';
        
        const prevButton = document.createElement('button');
        prevButton.className = 'slider-prev';
        prevButton.innerHTML = '<i class="fas fa-chevron-left"></i>';
        prevButton.addEventListener('click', showPrevTestimonial);
        
        const nextButton = document.createElement('button');
        nextButton.className = 'slider-next';
        nextButton.innerHTML = '<i class="fas fa-chevron-right"></i>';
        nextButton.addEventListener('click', showNextTestimonial);
        
        sliderControls.appendChild(prevButton);
        sliderControls.appendChild(nextButton);
        testimonialSlider.appendChild(sliderControls);
        
        // Agregar estilos a los controles
        const style = document.createElement('style');
        style.textContent = `
            .testimonial-slider {
                position: relative;
                padding-bottom: 50px;
            }
            .slider-controls {
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                gap: 15px;
            }
            .slider-prev, .slider-next {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #f0f5f9;
                border: none;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #2a5885;
                transition: all 0.3s ease;
            }
            .slider-prev:hover, .slider-next:hover {
                background-color: #2a5885;
                color: #fff;
            }
        `;
        document.head.appendChild(style);
        
        // Cambiar automáticamente cada 5 segundos
        setInterval(showNextTestimonial, 5000);
    }
    
    // Animación para los números en las tarjetas de estadísticas
    function animateStats() {
        const statCards = document.querySelectorAll('.stat-card h3');
        
        statCards.forEach(card => {
            const target = parseInt(card.getAttribute('data-target'));
            if (target) {
                // Comprobar si la animación ya se ha realizado
                if (!card.classList.contains('animated')) {
                    let count = 0;
                    const duration = 2000; // 2 segundos
                    const frameDuration = 16; // ~60fps
                    const increment = target / (duration / frameDuration);
                    
                    const counter = setInterval(() => {
                        count += increment;
                        if (count >= target) {
                            card.textContent = target;
                            clearInterval(counter);
                        } else {
                            card.textContent = Math.floor(count);
                        }
                    }, frameDuration);
                    
                    card.classList.add('animated');
                }
            }
        });
    }
    
    // Observador de intersecciones para animar cuando las tarjetas son visibles
    if ('IntersectionObserver' in window) {
        const statsContainer = document.querySelector('.stats-container');
        
        if (statsContainer) {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        animateStats();
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.5 });
            
            observer.observe(statsContainer);
        }
    }
    
    // Animación para las tarjetas de servicios
    const serviceCards = document.querySelectorAll('.service-card');
    
    if (serviceCards.length > 0) {
