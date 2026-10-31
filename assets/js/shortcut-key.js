// On a Mac, show the Mac shortcut in the search button's tooltip
document.addEventListener("readystatechange", () => {
  if (document.readyState === "interactive") {
    let isMac = navigator.platform.toUpperCase().indexOf("MAC") >= 0;
    let shortcutKeyElement = document.querySelector("#search-toggle .nav-link");
    if (shortcutKeyElement && isMac) {
      // The button label is "search" on all systems; only the tooltip mentions the Mac shortcut.
      document.querySelector("#search-toggle").title = "Search (shortcut: \u2318K)";
    }
  }
});
