// Blog post JavaScript
document.addEventListener('DOMContentLoaded', function() {
    console.log('Blog post loaded');
    
    // Add read time calculator
    const content = document.querySelector('.post-content');
    if (content) {
        const text = content.textContent;
        const wordCount = text.split(/\s+/).length;
        const readTime = Math.ceil(wordCount / 200); // Average reading speed
        
        const readTimeElem = document.createElement('p');
        readTimeElem.classList.add('read-time');
        readTimeElem.textContent = `Estimated read time: ${readTime} minute${readTime !== 1 ? 's' : ''}`;
        
        content.insertAdjacentElement('beforebegin', readTimeElem);
    }
});
