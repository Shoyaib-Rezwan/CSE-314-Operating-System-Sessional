// Contact page JavaScript
document.addEventListener('DOMContentLoaded', function() {
    console.log('Contact page loaded');
    
    const form = document.getElementById('contact-form');
    if (form) {
        form.addEventListener('submit', function(event) {
            event.preventDefault();
            console.log('Form submitted');
            alert('Message sent successfully!');
        });
    }
});
