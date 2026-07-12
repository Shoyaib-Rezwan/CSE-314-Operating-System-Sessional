// Services page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    console.log('Services page loaded');
    
    // Initialize service interactive elements
    const services = document.querySelectorAll('.service');
    services.forEach(service => {
        service.addEventListener('click', function() {
            console.log('Service clicked:', this.querySelector('h2').textContent);
        });
    });
});
