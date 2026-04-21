function toggleSidebar() {
    const sidebar = document.getElementById("sidebar");
    if (sidebar) {
        sidebar.classList.toggle("show");
    }
}

window.addEventListener("load", function () {
    const notices = document.querySelectorAll(".flash, .toast");
    if (!notices.length) {
        return;
    }

    setTimeout(function () {
        notices.forEach(function (notice) {
            notice.style.transition = "opacity 0.4s ease, transform 0.4s ease";
            notice.style.opacity = "0";
            notice.style.transform = "translateY(8px)";
        });
    }, 3200);
});
