// Simple client-side confirm action
function confirmDelete(taskTitle) {
    return confirm("Are you sure you want to delete the task: '" + taskTitle + "'?");
}

// Fade out or interactive UI triggers can be placed here if needed in the future
document.addEventListener("DOMContentLoaded", function () {
    // Focus search box or task input on load optionally
    const titleInput = document.getElementById("txtTitle");
    if (titleInput && !titleInput.value) {
        // titleInput.focus(); // Avoid stealing focus automatically, but template is ready
    }
});
